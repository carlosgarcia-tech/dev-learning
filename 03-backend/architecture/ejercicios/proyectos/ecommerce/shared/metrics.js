// shared/metrics.js - Métricas: counters y histograms

class Metrics {
  constructor() {
    this._counters = {};
    this._histograms = {};
  }
  inc(name, n = 1) {
    this._counters[name] = (this._counters[name] || 0) + n;
  }
  observe(name, value) {
    (this._histograms[name] = this._histograms[name] || []).push(value);
  }
  counter(name) { return this._counters[name] || 0; }
  histogram(name) { return this._histograms[name] || []; }
}

module.exports = { Metrics };
