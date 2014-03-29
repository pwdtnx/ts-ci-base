/**
 * Created by tanix on 2014/03/21.
 */

/// <reference path="reference.d.ts" />
/// <reference path="../src/index.ts" />

describe("test", () => {
    var expect = chai.expect;
    it("test1", () => {
        expect(Main.Main.calc()).equal(3);
    });
    it("test2", () => {
        var a = new A.A();
        expect(a.A()).equal(3);
    })
    it("test3", () => {
        expect(1).equal(1)
    })
})

