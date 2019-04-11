# task-api

API to store tasks 

## Install

```shell
bundle install
```

## Execute

```shell
rackup
```

## Routes

- Get 'api/v1/task': returns all the task ids in json format
- Get 'api/v1/task/[id]': returns the id, title, description, date created, assignee, reporter and status of the task with the id in the request in json, return 404 if the id is not found
- Post 'api/v1/task': saves a new task with the data received in json format (including the the id in the json is optional). The status is optional, if no status is provided the default status is new
	- Example:

		```json
		{
		    "title": "Finish service security hw",
		    "description": "finish hw before thursday midnight",
		    "date_created": "2019/04/11",
		    "assignee": "Xavier",
		    "reporter": "Soumya",
		    "status": "new"
		}
		```
