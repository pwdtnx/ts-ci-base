/**
* Created by tanix on 2014/03/22.
*/
var A;
(function (_A) {
    var A = (function () {
        function A() {
        }
        A.prototype.A = function () {
            return 3;
        };
        return A;
    })();
    _A.A = A;
})(A || (A = {}));
/**
* Created by tanix on 2014/03/21.
*/
/// <reference path="a.ts" />
var Main;
(function (_Main) {
    var Main = (function () {
        function Main() {
        }
        Main.calc = function () {
            return 3;
        };
        return Main;
    })();
    _Main.Main = Main;
})(Main || (Main = {}));
/**
* Created by tanix on 2014/03/21.
*/
/// <reference path="reference.d.ts" />
/// <reference path="../src/index.ts" />
describe("test", function () {
    var c = typeof chai !== "undefined" ? chai : require("chai");
    var expect = c.expect;
    it("test1", function () {
        expect(Main.Main.calc()).equal(3);
    });
    it("test2", function () {
        var a = new A.A();
        expect(a.A()).equal(3);
    });
    it("test3", function () {
        expect(1).equal(1);
    });
});
