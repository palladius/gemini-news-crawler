// https://stackoverflow.com/questions/74749172/how-to-use-custom-js-on-a-rails-7-view
function sayHi() {
    console.log("hi stackoverflow rails 7");
}

window.sayHi = sayHi;  // You must have this to expose your functions
