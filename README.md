About
===

Built in response to a live coding test for the University of Notre Dame. Limit 1 hour.

> Write a Ruby on Rails app that lets me track club memberships.  Scaffolding is fine; SQLite is fine. Do as much as you can in this hour, prioritizing items as you see fit.  Use GitHub. When you're done, provide me the repo URL, plus instructions on how to run the app, and be prepared to discuss your work.  

> *Classes*
- Clubs should have names, descriptions, and an attribute that states whether they are currently accepting members.  
- Users should have first / last names and date of birth.  
- Users may belong to more than one club.  

> *Validations*
- All fields should have sensible validations on data type and input.
- I should not be able to create a user with the same first/last/dob as another, nor assign the same user to a club twice.

> *Testing*
- Write tests for your app in whatever framework you prefer

> *View Layer*
- Clean up the scaffolding to eliminate unnecessary fields
- Provide drop-downs for field values where appropriate.
- On the club page, display a bulleted list of club member names.
- Next to the name, provide a button that removes the user from the club.  I should get a confirmation pop-up before this occurs.

> *Javascript*
- When creating a club, use client-side validation to limit the club name to 30 characters
- On submit, stop me from submitting if the club name is over 30 characters.  Alert me somehow of the problem.
- As I type, provide an indicator next to the text input that displays the number of characters

So basically I'm building meetup.com

Installation
===

1. Clone to local machine
2. `bundle install`
3. `rake db:create`
4. `rake db:migrate`
5. localhost:3000 and away you go!

Development
===

During Code Test
---

I was given a short hour to get as far as I could.

####Setup
Initially I set up a basic schmema
```ruby
  create_table "clubs", force: true do |t|
    t.string  "name"
    t.text    "description"
    t.boolean "accepting"
  end

  create_table "memberships", force: true do |t|
    t.integer "club_id"
    t.integer "user_id"
  end

  create_table "users", force: true do |t|
    t.string   "f_name"
    t.string   "l_name"
    t.date     "dob"
  end
```
And activerecord associations
```ruby
class Club < ActiveRecord::Base
  has_many :memberships
  has_many :users, through: :memberships
end

class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :club
end

class User < ActiveRecord::Base
  has_many :memberships
  has_many :clubs, through: :memberships
end
```

####Scaffolding
I ran a couple of scaffolding commands that got Users and Clubs to CRUD(Create, Read, Update, Delete.) I normally don't use scaffolding as I prefer to know what goes into my app, but in the interest of time I let it slide. Problem is that scaffolding generates alot of stuff you dont need. Let's take clubs for example
```ruby
class ClubsController < ApplicationController
  before_action :set_club, only: [:show, :edit, :update, :destroy]

  # GET /clubs
  # GET /clubs.json
  def index
    @clubs = Club.all
  end

  # GET /clubs/1
  # GET /clubs/1.json
  def show
  end

  # GET /clubs/new
  def new
    @club = Club.new
  end

  # GET /clubs/1/edit
  def edit
    @users = User.all
  end

  # POST /clubs
  # POST /clubs.json
  def create
    @club = Club.new(club_params)

    respond_to do |format|
      if @club.save
        format.html { redirect_to @club, notice: 'Club was successfully created.' }
        format.json { render :show, status: :created, location: @club }
      else
        format.html { render :new }
        format.json { render json: @club.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clubs/1
  # PATCH/PUT /clubs/1.json
  def update
    respond_to do |format|
      if @club.update(club_params)
        format.html { redirect_to @club, notice: 'Club was successfully updated.' }
        format.json { render :show, status: :ok, location: @club }
      else
        format.html { render :edit }
        format.json { render json: @club.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clubs/1
  # DELETE /clubs/1.json
  def destroy
    @club.destroy
    respond_to do |format|
      format.html { redirect_to clubs_url, notice: 'Club was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_club
      @club = Club.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def club_params
      params.require(:club).permit(:name, :description, :accepting)
    end
end
```
Now, actually most of that stuff is pretty good. I actually like the `set_club` method. It defines the `@club = Club.find(params[:id])` variable once and then calls it before the `edit`, `show`, `update`, and `delete` pages. I have a lot of apps where I'm writing that line over and over- I might just start using that.

What I don't like, or need, is all those json responses. I believe that eventually all apps are going over to a rails/django/node back-end and a seperate angular/backbone front-end. But not yet. Right now I can clean up that scaffolding for the `create`, `update`, and `destroy` methods by simply removing the json responses.

```ruby
def create
  @club = Club.new(club_params)
  if @club.save
    redirect_to @club, notice: 'Club was successfully created.'
  else
    render :new
  end
end
  
def update
  if @club.update(club_params)
    redirect_to @club, notice: 'Club was successfully updated.'
  else
    render :edit        
  end
end

def destroy
  @club.destroy
  redirect_to clubs_url, notice: 'Club was successfully destroyed.'
end
```
Much prettier.


####Verification of Uniqueness
The next thing I tackled in that hour was verification of unique users. I had found that I could get all fields unique apart from each other. But, that's not very useful as there are of course people with similar first names and so on. I used the `validates :l_name, :uniqueness => { :scope => :f_name, :case_sensitive => false }` method to find uniqueness on two fields. _Still working on 3._

####Membership Association
Next task was to get the Membership table working.

Through the rails console I can test `has_many :x_objects, through: :y_object` relationship
```ruby
2.1.1 :001 > User.first
 => #<User id: 1, f_name: "Ryan", l_name: "Snodgrass", dob: "1986-04-28">
2.1.1 :002 > User.first.clubs
 => #<ActiveRecord::Associations::CollectionProxy []>
2.1.1 :003 > Club.first
 => #<Club id: 3, name: "club", description: "skdj", accepting: true>
2.1.1 :004 > Club.first.memberships
 => #<ActiveRecord::Associations::CollectionProxy []>
2.1.1 :005 > Club.first.users
 => #<ActiveRecord::Associations::CollectionProxy []>
 ```
 
I see that calling through clubs to users and vice versa will not error out. Which means that it should be working correctly. But, before I could test any further, my short hour was over.

---

Additions
---
Over the weekend on my own time I decided to keep adding. I wanted users to sign up and be able to create a club. Only the user that creates the club can make changes. I will be using the [devise gem](https://github.com/plataformatec/devise) for authentication.

###Devise Gem

The Devise Gem is mostly straight forward as long as you don't start messing with things as it gets finicky once you start customizing things. After putting the gem in the gemfile and running `rails generate devise:install` and then `rails generate devise User`, it's a couple quick links copy pasted from an older app to get registrations working. Make sure to put `before_action :authenticate_user!` in each contoller to validate sign in.

A quick gotcha I encountered when I put in the Devise gem was `f_name` and `l_name` were no longer being saved into the DB. I was getting an unpermitted parameters error when updating and creating
```
Started PUT "/users" for 127.0.0.1 at 2014-09-14 14:37:44 -0400.Processing by Devise::RegistrationsController#update as HTML.  Parameters: {"utf8"=>"✓", "authenticity_token"=>"smS7azhqJEBQx1bKVIaSNgUyocT8EpYaZi7ZkkAFDMk=", "user"=>{"f_name"=>"Ryan", "l_name"=>"Snodgrass", "dob"=>"2005-06-15", "email"=>"res0428@yahoo.com", "password"=>"[FILTERED]", "password_confirmation"=>"[FILTERED]", "current_password"=>"[FILTERED]"}, "commit"=>"Update"}
User Load (0.2ms)  SELECT  "users".* FROM "users"  WHERE "users"."id" = 5  ORDER BY "users"."id" ASC LIMIT 1.  User Load (0.2ms)  SELECT  "users".* FROM "users"  WHERE "users"."id" = ? LIMIT 1  [["id", 5]].Unpermitted parameters: f_name, l_name, dob
```

Normally a pretty easy error. I might have missed the defined parameters in the users_controller or something simple like that. But on checking- 
```ruby
#app/controllers/users_controller.rb
def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
end
  
def user_params
  params.require(:user).permit(:f_name, :l_name, :dob)
end
```
Nope all there. Strangely all the unpermitted items were there, but none of the `password` or `email` that _IS_ going through. Even stranger - debugger is completely being ignored. Which tells me that the UserController isn't even being hit.

If we look closely at the console output we can see that it tells us `Processing by Devise::RegistrationsController#update` is where it is actually processing. But where is that? The source files do not contain that specific controller. 

Fortunately Devise's documentation tells us (right on the front page) that to add new attributes to a form- put in their `configure_permitted_parameters` method in the application controller. So I tried- 
```ruby
#app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:f_name, :l_name, :dob, :email, :password, :password_confirmation, :current_password) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:f_name, :l_name, :dob, :email, :password, :password_confirmation, :current_password) }
  end
end
```

And the error went away! Problem solved!

###User Permissions
For a little bit extra I just want a simple check that only the user that started the club may edit and add members. Normally I would use a `foriegn_key` with a `belongs_to :user` but, that might not work as I'm already associating users with memberships. Instead I'll have a column `created_by` with foriegn keys and upon club creation save the `current_user.id` in the column. Reference that when checking whether `current_user.id == @club.created_by`. I've used the CanCanCan gem before with awesome results, but in this case I feel it would be a little bit of over-kill when in about 3 seconds I can just write a little bit of logic to check user permissions.

First thing, I need to add a 'created_by' column in the club table.
```
rails g migration AddCreatedByToClubs created_by:integer
```
This creates a migration file and auto generates the `add_column` with what I want in it. Always check anyways and make sure it generated your migration file correctly.
```ruby
class AddCreatedByToClubs < ActiveRecord::Migration
  def change
    add_column :clubs, :created_by, :integer
  end
end
```
Looks good.
```
rake db:migrate
```

In the club form template add in `created_by` as a hidden value. Because the only user able to update the club is the one who created it, I'd say it's ok to set the current user in the form template.
```haml
/ app/views/clubs/_form.html.haml
= f.hidden_field :created_by, :value => current_user.id
```
And in the club controller add in the `created_by` column in the salting
```ruby
#app/controllers/clubs_controller.rb
def club_params
  params.require(:club).permit(:name, :description, :accepting, :created_by)
end
```

Now let's put in the quick logic.
```haml
/ app/views/clubs/index.html.haml
- @clubs.each do |club|
  %tr
    %td= club.name
    %td= club.description
    %td= club.accepting
    %td= link_to 'Show', club
    - if current_user.id == club.created_by
      %td= link_to 'Edit', edit_club_path(club)
      %td= link_to 'Destroy', club, method: :delete, data: { confirm: 'Are you sure?' }
```

Bam! Done.  
While we're here let's fix the input field for `accepting` to something more acceptable since scaffolding auto generates an input text box for a boolean value(lol wut?) I'm gonna make it a simple checkbox.
```haml
/ app/views/clubs/_form.html.haml
= f.label :accepting
%br/
= f.check_box :accepting
```

###Memberships

Now onto the meat of the app. Getting users to associate with clubs. In a real app this would probably be a very involved feature. The club owner could search for users and send a notification to the prospect's email with the invitation. Meanwhile the prospect could shop for other clubs and then send a notification to the club owner for an invitation. There could be growler notifications and popups and recommendations and that's all very good, but this could go on forever. For now, I just want admin users to invite/expell people.

First thing we need to do is add a way to view all users on the view layer. Only the club administrator can make changes so I'll simply put the invitation function inside the edit page. For organization they're being listed as two types- those that are members, and those that are not.
```haml
/ app/views/clubs/edit.html.haml
%h1 Editing club
= render 'form'

- @users.each do |u|
  = u.f_name
  = u.l_name
  - if @club.memberships.include?(u)
    %h5 Current Member
    / logic to expell member.
  - else
    %h5 Not a Member
    = form_for([@club, @new_membership]) do |f|
      = f.hidden_field :user_id, :value => u.id
      = f.hidden_field :club_id, :value => @club.id
      = f.submit 'Invite Member'

= link_to 'Show', @club
= link_to 'Back', clubs_path
```

Great. Now Let's update the routes and get some nesting going. Because I could eventually want users to invite themselves for whatever reason, I need both clubs and users nesting memberships.
```ruby
resources :users, :clubs do
    resources :memberships
end
```
Good stuff.

Now we need to update the membership controller.
```ruby
# app/controllers/clubs_controller.rb
class MembershipsController < ApplicationController
  def edit
    @users = User.all
    @new_membership = Membership.new
  end
  
  def create
    @new_membership = Membership.new(membership_params)
    if @new_membership.save
      redirect_to edit_club_path(params[:club_id])
    else
      redirect_to :back
    end
  end

  private

  def membership_params
    params.require(:membership).permit(:user_id, :club_id)
  end
end
```
Creating memberships now works.

---

Deletion; however, is going to be much different. In fact, deletion is the trickiest part of the whole app.

Because Membership is it's own model, it's easiest to just act on that instead of `@clubs.memberships`/`@user.memberships` querying around activerecord associations like a mad man. First we need to update the `memberships_controller.rb`
```ruby
# app/controllers/memberships_controller.rb
  def destroy
    @membership = Membership.find(params[:id])
    if @membership.destroy
      redirect_to edit_club_path(params[:club_id])
    else
      redirect_to :back, notice: 'Whoopsies'
    end
  end
```

The trickiest part was getting the view to hit a nested resource controller without adding its own seperate route. 

For example I could have easily acted like every other CRUD and added a specifc route
```ruby
# config/routes
  resources :users, :clubs do
    resources :memberships
  end
#wasn't going to add this
  resources :memberships
```
But I knew there was a solution for this and wanted to challenge myself. It was especially hairy when Debugger was giving me an error when I knew that what I had should be running correctly.  
```ruby
Started DELETE "/clubs/10/memberships/10" for 127.0.0.1 at 2014-09-15 17:12:05 -0400
Processing by MembershipsController#destroy as HTML
  Parameters: {"utf8"=>"✓", "authenticity_token"=>"ZLhJfFY9vuXXuht/gQY9SIgWVXEEzq8rg9rbTsI0WKc=", "commit"=>"Expell Member", "club_id"=>"10", "id"=>"10"}
  Membership Load (0.5ms)  SELECT  "memberships".* FROM "memberships"  WHERE "memberships"."id" = ? LIMIT 1  [["id", 10]]
/Users/masterblaster/.rvm/gems/ruby-2.1.1/gems/actionpack-4.1.4/lib/action_controller/metal/implicit_render.rb:5
default_render unless performed?

[0, 9] in /Users/masterblaster/.rvm/gems/ruby-2.1.1/gems/actionpack-4.1.4/lib/action_controller/metal/implicit_render.rb
   1  module ActionController
   2    module ImplicitRender
   3      def send_action(method, *args)
   4        ret = super
=> 5        default_render unless performed?
   6        ret
   7      end
   8
   9      def default_render(*args)
```
Turns out it the error code above is a glitch in Debugger before it hit a missing template error.

The eventual solution was a reworking of the edit page to split users from `@memberships`(current members) and `@users`(non members.) First update the `clubs_controller`
```ruby
# app/controllers/clubs_controller.rb
  def edit
    @users = User.all
    @memberships = @club.memberships
    @new_membership = Membership.new
  end
  
```
And the eventual solution in the view
```haml
/ app/views/clubs/edit.html.haml
%h1 Editing club
= render 'form'
%ul
  %h3 List of Current Members
  - @memberships.each do |m|
    %li= m.user.f_name + " " + m.user.l_name + ' Current Member'
    = form_for(m, url: club_membership_path(@club, m), data: { confirm: "Are you sure?" }, :html => {:method => 'delete'}) do |f|
      = f.hidden_field :club_id, :value => @club.id
      = f.submit 'Expell Member'
    
    %br

  %h3 List of Non Members
  - @users.each do |u|
    - unless @club.users.include?(u)
      %li= u.f_name + " " + u.l_name
      %h5 Not a Member

      = form_for([@club, @new_membership]) do |f|
        = f.hidden_field :user_id, :value => u.id
        = f.hidden_field :club_id, :value => @club.id
        = f.submit 'Invite Member'

= link_to 'Show', @club
= link_to 'Back', clubs_path
```
The trick to getting the above working was in the `form_for`
```ruby
= form_for(m, url: club_membership_path(@club, m), data: { confirm: "Are you sure?" }, :html => {:method => 'delete'}) do |f|
```
Because the controllers were nesting routes `club_membership_path()` was expecting two arguments - the ids for `@club` and the membership in question.

I threw in the confirmation before deletion for good measure.

---
Finished
---
HURRAY THE APP IS NOW FULLY FUNCTIONAL! 
- I have users signing in with full registration. 
- They can CRUD clubs. 
- The creator of the club becomes admin
- Admin can invite and expell members

Not bad for a weekend app!

Extra
===

I put in some logic to have an always present home link, but not displayed when already at home(root.) By having it in the layout/application after the `= yield` ensures it displays on everypage keeping things DRY.
```haml
/ app/views/layouts/application.html.haml
= yield
%br
- unless request.env['PATH_INFO']  == "/"
  = link_to "Go Back Home", root_path, :class => 'navbar-link'
```