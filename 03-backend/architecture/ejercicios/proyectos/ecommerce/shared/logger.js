// shared/logger.js - Logger estructurado JSON con trace_id

class Logger {
  constructor() { this.logs = []; }
  log(level, msg, trace_id = null, extra = {}) {
    const entry = { ts: new Date().toISOString(), level, msg, trace_id, ...extra };
    this.logs.push(entry);
    // En producción: console.log(JSON.stringify(entry)) a stdout
    return entry;
  }
  info(msg, trace_id, extra = {}) { return this.log('info', msg, trace_id, extra); }
  error(msg, trace_id, extra = {}) { return this.log('error', msg, trace_id, extra); }
}

module.exports = { Logger };
