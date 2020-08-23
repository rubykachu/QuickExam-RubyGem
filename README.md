# QuickExam

[![Gem Version](https://badge.fury.io/rb/quick_exam.svg)](https://badge.fury.io/rb/quick_exam)

You can shuffle or randomize quiz questions and answers. Shuffling is also an effective way of preventing cheating because no two learners get questions in the same order while taking the same quiz.

Currently, the gem `quick_exam` **only supports txt** format. With the following rules:

| Description | Example |
|-------------|------------------------|
| Format for a question. Not case sensitive and can custom format | `Q1.` or `Q1)` or `Q1/` |
| Format for an answer. Not case sensitive | `A.` or `A)` or `A/` |
| Format for an answer correct. Not case sensitive and can custom format | `!!!Correct` |

In the future, I will analyze the file in _.docx_ or _.doc_ format

**Sample data**
```
  Q1. How do you run migration?
  (Select multi choices)

  a) rails db:migrate !!!True
  b/ rake db:migrate !!!True
  c. rake db:migration
  d. rails db:migration


  Q20) How to access console log screen in rails?

  (Select multi choices)

  A) rails console !!!True
  B/ rake c !!!True
  C. rake console --sandbox !!!True
  D. rails c --sandbox !!!True

  Q333/ What is the purpose of using div tags in HTML?

  1) For creating different styles.
  2. For creating different sections. !!!True
  3/ For adding headings.
  D. For adding titles.
```


## Installation

Install the latest release yourself as:

```bash
$ gem install quick_exam
```

In Rails or others, add it to your Gemfile:

```ruby
gem 'quick_exam'
```

And then execute

```bash
$ bundle install
```

## Usage

### From CLI

Export shuffle or randomize quiz question and answers

```bash
$ quick_exam export path_file \
                    --shuffle-question=true \ # alias: -q
                    --shuffle-answers=true \  # alias: -a
                    --same-answer=false \     # alias: -s
                    --count=4 \               # alias: -c
                    --f-ques="Question" \     # alias: -Q
                    --f-corr="!!!Right" \     # alias: -C
                    --dest="./folder"         # alias: -d
```

Run command help

```bash
$ quick_exam help export
```
to show options:

```
Usage:
  quick_exam export FILE_PATH [options]

Options:
  -q, [--shuffle-question=true|false]  # Shuffle the question
                                       # Default: true

  -a, [--shuffle-answer=true|false]    # Shuffle the answer
                                       # Default: false

  -s, [--same-answer=false]            # The same answer for all questionnaires
                                       # Default: false

  -Q, [--f-ques=Q]                     # Question format. Just prefix the question
                                       # Default: Q

  -C, [--f-corr=!!!T]                  # Correct answer format
                                       # Default: !!!T

  -c, [--count=2]                      # Number of copies to created
                                       # Default: 2

  -d, [--dest=~/quick_exam_export/]    # File storage path after export

shuffled questions and answers then export file
```

### From script ruby

To process raw data and get results after analysis

```ruby
analyzer = QuickExam::Analyzer.run(path_file)
```

The object `analyzer` will have methods:

```bash
.file          # Return the file
.total_line    # Return total line of the file
.records       # Return the data after analyzing
```

To shuffle quiz question and answers

```ruby
analyzer.records.mixes(count, shuffle_question: true, shuffle_answer: false, same_answer: false)
```

The method `mixes` have 3 arguments:

```bash
count:               # Number of copies to created
shuffle_question:    # Shuffle quiz question. Default: true
shuffle_answer:      # Shuffle answer. Default: false
same_answer:         # Same answer for all questionnaires. Default: false
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tm-minhtang/quick_exam/issues. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected

1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Added some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request

---
_Authors: Tang Quoc Minh [vhquocminhit@gmail.com]_
