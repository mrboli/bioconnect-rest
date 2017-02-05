# Bioconnect REST API V1

`Ruby v2.4.0, Rails 5.0.1 (both latest stable)`

##### To run the project, just use `rails s`
_API spec: https://gist.github.com/anaqvi15/3902991918e3e4b0b4dcc754c0bba74c_

#### This is a simplistic API that has two models which endpoints are structured off of:

* Timecards
* TimeEntries

## Libraries and Tech Choices

* RSpec
* Factory Girl

##### RSpec

The frameworks chosen for this project were very simple. I personally have not worked in Rails for a while, and just wanted some basic, well used, well-supported community tools. RSpec has been the defacto unit testing framework in the past. It has a very nice spec-based syntax.

The only downside that I'm personally aware of is that apparently that the original creator didn't create the framework to Ruby's style. There's a lot of unit testing frameworks out there, and if this was a production level app I would spend quite a bit of time doing research on what are the benefits and cons of different frameworks considering not only the project, but also community support.

##### Factory Girl

It's advisable to use Factories instead of fixtures. The choice for this framework was the same as for RSpec. I've been out of the space for a while. It's a common choice, and if I were to do this for real I would have to do a lot more due dillegence on what to choose.

## Tech highlights

##### API Controllers

The application controller has been taken off of `ApplicationController::API` instead of `base` to simplify the authenticity issues of running the API. I'm making the assumption that we will only receive JSON, and that has much less chances of having vulnerabilities to attacks. This should technically be enforced though. If this API service was used amongst other rails functionalites in a web app, you would want to create a base `apis_controller`, have that inherit from the API base, then all api controllers inherit off of that.

JSON was chosen as the dataformat of choice. It's pretty standard these days to use tons of javascript heavy frameworks. It's nicer to parse JSON insetad of XML or other formats in the frontend. On top of that, it has way less overhead.

##### `<model>_from_id`

In both `timecards_controller` and `time_entries_controller` you will notice this pattern:

```
  def timecard_from_id
    # May also use .find_by_id, but this is clearer
    Timecard.find(params[:id]) if Timecard.exists? id: params[:id]
  end
```

I personally think using `.exists?` is a much clearer way of finding a potential id in a certain model from a readability perspective. When you use `find_by_id`, you will have to infer that it returns something conditionally by the conditional statement itself, but not by the querying function. `.exists?` also uses the question mark syntax which makes it very clear that it is conditional.

I personally would have also prefered to put the `.exists` check in the model helper class itself, which I've put into `timecard_helper` as an example, but didn't use it for readability's sake. If the whole dev team is aware of a pattern of use like that, then definitely it should be used. But to call something like `Timecard.exists? <some_id>` might be confusing in the scope of this coding challenge.

Also, you'll notice that the `<model>_from_id` pattern is called in most controller methods. I debated whether or not to load it into an instance variable and put it in a before filter. If this API was more extensive (aka even one more model to do the same thing) I would have.

#### Common patterns in API

I noticed that each of the same REST functionality in each of the API controllers, the code looked very similar. There's a chance to make a REST API module to handle this dynamically by the class that it's called from. You can infer the model that it's referring to by the class name of the controller. There is a convention issue here in that the API controllers used this way are now dependant upon the convention of the naming of the model and controller. It's still advisable to use this, but it needs to be documented well.

#### Updating total time on Timecards

I chose to do this as a before filter in the `time_entries_controller`. It may seem obvious, but alternatives are to have the `Timecard.update_total_time` function called after specific controller or model methods.

#### Timecard `total_time` as `:bigint`

I chose to store the total time as seconds. You will most likely never need to pay somebody on the order of milliseconds -- if this is the case, we can always use a float, but it is unlikely. I chose to use bigint instead of a normal int because in the event that there are bad dates included (for example: `DateTime.new` instead of `Time.new`) will create a huge timegap. When the time is calculated, you will create something too big for the datatype and cause an exception.

#### Timecard `update_total_time`

This method is somewhat interesting.

It sets `total_time` on Timecards to nil if there is only one date (example from deleting a TimeEntry form a Timecard). Note, this will set the `total_time` to `0` if there are two TimeEntries, and one is updated to have a nil date. Invalid dates are not handled yet and this is a unhandled case.

The method works like this:

1. Trims off nil dates and returns a has of `time_entries` related to a Timecard
2. Gets the max and min dates in the full `time_entries` hash. (supports 2+ TimeEntries)
3. Calculates the time difference, turns it into seconds then sets it conditionall onto the Timecard.

Again, this is triggered on a before filter on select HTTP methods in the `time_entries_controller`

## Unit Tests

#### Status Codes

I decided to use the text-readable versions of the status codes instead of the numbers. I think it looks nicer, but it's definitely easier in some cases to just see the numbers pop out of a semantic-heavy language such as Ruby. It might be worth changing it to use the numeric status codes in the future.

#### Timecard Factory
_`spec/factories/timecards.rb` && `spec/apis/time_entries_controller_spec.rb`_

With Factory Girl, I created a trait that takes in two optional parameters: `amount` and `datetimes` (array).
`amount` decides how many time_entries are created per related timecard instance.
If no `datetimes` array is provided, it will instanciate all `time` properties on the time_entires to Time.now. If you provide a list of times (which is useful in testing different total_time edge cases), it will use those and populate the TimeEntry `time` properties.

### TODO: 

* OAuth / some form of Api Authenticity
* Clean up tests with it_behaves_like
