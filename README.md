AB Tech Tracker
===============

The tech tracker is a specialized web application that helps you administrate AB Tech. It is extremely custom-tailored for CMU's AB Tech, but it could probably be adapted for other production companies.

The core functionality includes:
* Event planning
* Incoming email management
* Financial tracking, including integration with CMU's JFC budgets and the Oracle accounting system
* Membership management, including payroll and timecard generation

History
-------
The tracker was originally written in ~2003. The original project was written in perl-style Rails 1.x, stored in an SVN repository and hosted on the original "pickle" server.

In 2009, the code was moved into git and soon thereafter uploaded to Github.

In the following few years, the tracker was maintained, new features were added, and it was upgraded to Rails 2.3.

Development Notes
-----------------

### Source Control

* `production` should always be deployable.
* Commit mainline changes to `master`.
* When ready and reviewed, merge master to production.
* For larger features, it probably makes sense to comit to a branch and submit a pull request on github onto master.

### Deployment

```shell
cap deploy:pending:diff # Preview changes going out ot server.
cap deploy # Deploy production branch.
cap -s branch=master # Deploy master branch.
cap -s branch=my_feature # Deploy my_feature branch.
```

