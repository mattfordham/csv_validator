## Usage

Add to your Gemfile:

```ruby
gem 'csv_validator'
```

Run:

```
bundle install
```

Then add the following to your model:

```ruby
validates :my_csv_file, :csv => true
```

This will check to see if it is a properly formed CSV file. 

## Other validation options

There are a handful of other options for more specific validation too. A complete list is below... note that you wouldn't use all simultaneously. 

```ruby
validates :my_csv_file, :csv => {
                          :columns => 3, # an exact number of columns
                          :max_columns => 10, # a maximum number of columns
                          :min_columns => 1, # a minimum number of columns
                          :rows => 20, # an exact number of rows
                          :max_rows => 30, # a maximum number of rows
                          :min_rows => 2, # a minimum number of rows
                          :email => 0, # will check to make sure all emails in specified column are valid email addresses
                          :numericality => 0, # will check to make sure all values in specified column are numerical
                        }
```

