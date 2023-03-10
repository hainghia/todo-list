
## Git Repositories

- [GitHub](https://github.com/hainghia/todo-list)
- [GitLab](https://gitlab.com/hainghia/todo-list)
- [Bitbucket](https://bitbucket.org/hainghia/todo-list)

### Remote repository

```shell
git remote -v

git remote add origin git@github.com:hainghia/todo-list.git
git remote add gitlab git@gitlab.com:hainghia/todo-list.git
git remote add bitbucket git@bitbucket.org:hainghia/todo-list.git

git add .; git commit -asm "Initial commit";git push origin main; git push gitlab main; git push bitbucket main
```

# PHP TEST
This is a basic one to check coding behavior, style, and basic techniques before the interview
round. Thank you for your cooperation.
CONTENT:
You need a web system to manage your work named “TodoList” with the below functions:
1. Functions to Add, Edit, Delete Work. A work includes information of “Work Name”, “Starting
   Date”, “Ending Date” and “Status” (Planning, Doing, Complete)
2. Function to show the works on a calendar view with: Date, Week, Month (can use third-party
   library)
   REQUEST:
1. To do with PHP programming language follows MVC. PLEASE DO NOT USE ANY
   FRAMEWORK
2. To do coding convention follows PSR
3. To apply UNIT TEST to test your functions
4. To use GIT and GIT Flow to manage your code
5. Please do your best, no need to complete all contents if you cannot
