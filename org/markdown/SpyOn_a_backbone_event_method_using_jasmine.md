 #+TITLE: How to mock event method in backbone

 #+KEYS: JS

 #+DATE: <2015-04-20 Mon>

 #+AUTHOR: Cao Xiaoqi

mock event method for js.

## How to mock event method in backbone


When we develop some project by useing Backbone framework. We usually to add some events and bind some function.

#### 1. We write our code.

We create a view name MyView extend Backbone.View

We bind a event on `.submit_btn` button, and a callback function `submit`.

code:

```
MyView = Backbone.View.extend({
	events: {
		".submit_btn click": "submit"
	},
	submit: function() {
	}
});
```

#### 2. We write our test code.

We create a instance of MyView, and mock `submit` function.

We use jQuery to click this button.

And then to check the method `submit` that was been called.

code:

```
describe("submit", function() {
	it("should be called when click submit button", function() {
		var myview = new MyView();
		spyOn(myview, "submit");
		$(".submit_btn").click();
		except(myview.submit).toHaveBeenCalled();
	});
});
```

When we run our test code, it doesn't work, there are some error.

Why???

#### 3. How to fix it?

There are a same question on stackoverflow
[SpyOn a backbone view method using jasmine](http://stackoverflow.com/questions/7899474/spyon-a-backbone-view-method-using-jasmine)

These answers tell us, we need to call `myview.delegateEvents()` after use `spyOn(...)` to mock event method.

Use the fllowing code, it will work fine.

code:

```
describe("submit", function() {
	it("should be called when click submit button", function() {
		var myview = new MyView();
		spyOn(myview, "submit");
		myview.delegateEvents();	//Add a new line to fix this issue.
		$(".submit_btn").click();
		except(myview.submit).toHaveBeenCalled();
	});
});
```

#### 4. Why use delegateEvents() ?

Because when we use `spyOn(..)` to mock some method, it will create a proxy of current obj and override this method.

In this case, we use `spyOn(myview, "submit")` to create a new proxy and override `submit` method. On events list, we just bind the origin `submit` method of origin instance, not proxy instance.

So we need to sue `delegateEvents()` to refresh the events list.

