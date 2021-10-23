var exec = require('cordova/exec');
var SquarePOS = function() {
};
SquarePOS.prototype.initTransaction = function(options, success, fail) {
    if (!options) {
        options = {};
    }
    var params = {
        amount: options.amount ? options.amount : 1,
        currencyCode: options.currencyCode? options.currencyCode : "GBP",
        squareApplicationId: options.squareApplicationId ? options.squareApplicationId : "",
        squareCallbackURL: options.squareCallbackURL? options.squareCallbackURL : "",
        state: options.state ? options.state : "",
        notes: options.notes ? options.notes : "",
        customerId: options.customerId ? options.customerId : ""
    };
    return cordova.exec(success, fail, "SquarePOS", "initTransaction", [params]);
};
window.squarePOS = new SquarePOS();
  
