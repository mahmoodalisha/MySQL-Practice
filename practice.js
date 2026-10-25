var x = 10;
function foo() {
    console.log(x);
    var x = 20;
    function bar() {
        console.log(x);
    }
    bar();
}
foo();