#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

COMPOSE=(docker compose -f docker-compose.yml)
PORT="${EXPERIMENT_PORT:-18080}"
GAP_SECONDS="${GAP_SECONDS:-2}"
INTERVAL_MS="${INTERVAL_MS:-25}"
RESULTS_DIR="$ROOT/results"
TRAFFIC_PID=""

cleanup() {
  if [ -n "$TRAFFIC_PID" ] && kill -0 "$TRAFFIC_PID" 2>/dev/null; then
    kill -INT "$TRAFFIC_PID" 2>/dev/null || true
    wait "$TRAFFIC_PID" 2>/dev/null || true
  fi
  "${COMPOSE[@]}" down --remove-orphans >/dev/null 2>&1 || true
}
trap cleanup EXIT

render_proxy_config() {
  local slot="$1"
  sed "s/__UPSTREAM__/${slot}/g" nginx/nginx.conf.template > nginx/nginx.conf
}

switch_proxy() {
  local slot="$1"
  render_proxy_config "$slot"
  "${COMPOSE[@]}" exec -T proxy nginx -s reload >/dev/null
}

wait_for_proxy() {
  for _ in $(seq 1 40); do
    if curl -fsS "http://localhost:${PORT}/" >/dev/null 2>&1; then
      return 0
    fi
    sleep 0.1
  done
  echo "Proxy did not become ready" >&2
  exit 1
}

start_environment() {
  render_proxy_config blue
  "${COMPOSE[@]}" down --remove-orphans >/dev/null 2>&1 || true
  "${COMPOSE[@]}" up -d
  wait_for_proxy
}

start_traffic() {
  local output="$1"
  python3 scripts/traffic.py \
    --url "http://localhost:${PORT}/" \
    --interval-ms "$INTERVAL_MS" \
    --output "$output" &
  TRAFFIC_PID=$!
  sleep 0.5
}

stop_traffic() {
  kill -INT "$TRAFFIC_PID"
  wait "$TRAFFIC_PID" || true
  TRAFFIC_PID=""
}

run_current_order() {
  start_environment
  start_traffic "$RESULTS_DIR/current-order.csv"
  "${COMPOSE[@]}" stop blue >/dev/null
  sleep "$GAP_SECONDS"
  switch_proxy green
  sleep 0.5
  stop_traffic
  python3 scripts/analyze.py \
    --input "$RESULTS_DIR/current-order.csv" \
    --output "$RESULTS_DIR/current-order-summary.json"
  cleanup
}

run_improved_order() {
  start_environment
  start_traffic "$RESULTS_DIR/improved-order.csv"
  switch_proxy green
  sleep "$GAP_SECONDS"
  "${COMPOSE[@]}" stop blue >/dev/null
  sleep 0.5
  stop_traffic
  python3 scripts/analyze.py \
    --input "$RESULTS_DIR/improved-order.csv" \
    --output "$RESULTS_DIR/improved-order-summary.json"
  cleanup
}

rm -rf "$RESULTS_DIR"
mkdir -p "$RESULTS_DIR"

run_current_order
run_improved_order
printf 'Results written to %s\n' "$RESULTS_DIR"
