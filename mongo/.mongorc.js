// always pretty print results
DBQuery.prototype._prettyShell = true;

// don't pretty print results
DBQuery.prototype.ugly = function () {
  this._prettyShell = false;
  return this;
};
