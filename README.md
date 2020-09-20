# QuickExam

[![Gem Version](https://badge.fury.io/rb/quick_exam.svg)](https://badge.fury.io/rb/quick_exam)

You can shuffle or randomize quiz questions and answers. Shuffling is also an effective way of preventing cheating because no two learners get questions in the same order while taking the same quiz.

The gem `quick_exam` **only supports txt, docx and Webpage html from Word** format. You can completely change the format of the questions and answers.


| Description | Example |
|-------------|------------------------|
| Format for a Question: Not case sensitive. The starting must be letters | `Q`, `Question` or `Câu` etc... |
| Format for an Answer: Not case sensitive. Starting with a letter or a number | `A`, `a` or `1`, `2` etc... |
| Format for an Correct answer: Not case sensitive | `!!!T` |

**Sample data**
```
Q1. Who are all ________ people?
A. this
B. those !!!T
C. them
D. that

Q2. Claude is ________.
A. Frenchman
B. a French !!!T
C. a Frenchman
D. French man

Q3. I ____ a car next year.
A. buy
B. am buying !!!T
C. going to buy
D. bought
```

[Clip demo](https://recordit.co/yl5b75lq8U)

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

### From CLI to export shuffle or randomize quiz question and answers

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

### From script ruby to process raw data and get results after analysis


```ruby
analyzer = QuickExam::Analyzer.new(path_file, f_ques: '', f_corr: '')
analyzer.analyze
```

The object `analyzer` will have methods:

```bash
.records       # Return the data after analyzing
.total_line    # Return total line of the file
.f_ques        # Return the format question
.f_corr        # Return the format correct answer
```

To shuffle quiz question and answers

```ruby
analyzer.records.mixes(count, shuffle_question: true, shuffle_answer: false, same_answer: false)
```

The method `mixes` have 3 arguments:

```bash
count:               # Require. Number of copies to created
shuffle_question:    # Optional. Shuffle quiz question. Default: true
shuffle_answer:      # Optional. Shuffle answer. Default: false
same_answer:         # Optional. Same answer for all questionnaires. Default: false
```

## Trick: Keep format Word

_Commonly used for mathematical or chemical formats_

`From Word > Save As > Save with format Webpage html`

**Step 1:**
![image](https://user-images.githubusercontent.com/26104119/93707761-8a5a7080-fb5b-11ea-9df5-ca34a603ab4b.png)

**Step 2:**
![image](https://user-images.githubusercontent.com/26104119/93707825-e1f8dc00-fb5b-11ea-8518-af07415ba4f3.png)

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
