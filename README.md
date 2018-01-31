# Comment API
[![Build Status](https://travis-ci.org/kyleboss/commentAPI.svg?branch=master)](https://travis-ci.org/kyleboss/commentAPI)
[![Maintainability](https://api.codeclimate.com/v1/badges/f0231112ab669356d56b/maintainability)](https://codeclimate.com/repos/5a6cce167644ea0295000f1e/maintainability)
<a href="https://codeclimate.com/repos/5a6cce167644ea0295000f1e/test_coverage"><img src="https://api.codeclimate.com/v1/badges/f0231112ab669356d56b/test_coverage" /></a>

The Comment API acts as an interface for a doctor commenting system.

## Pre-Existing Data
To assist with getting a new Comment API System up-and-running, the system is pre-seeded with four doctors, four 
groups, four specialties, eight authors, each of which have provided two comments/ratings. We use the Faker gem, thus
the data might be a little...odd. :)

## CRUD API 
Each and every object has been provided with CRUD actions. Let's take a look at comments, for an example.

### Read
List all of the Authors

`$ curl -H 'Content-Type: application/json' -H 'Accept: application/json' -X GET 
http://comment-api.us-west-2.elasticbeanstalk.com/authors`

```
[
    {
        "id": 1,
        "name": "Larue Jaskolski",
        "created_at": "2018-01-31T03:54:40.000Z",
        "updated_at":"2018-01-31T03:54:40.000Z"
    }
]
```

Also, the interface allows for reading a single, specific author.

`$ curl -H 'Content-Type: application/json' -H 'Accept: application/json' -X GET 
http://comment-api.us-west-2.elasticbeanstalk.com/authors/1`

```
{
    "id": 1,
    "name": "Larue Jaskolski",
    "created_at": "2018-01-31T03:54:40.000Z",
    "updated_at": "2018-01-31T03:54:40.000Z"
}
```

### Update
To update the author, use the update route interface provided.

`$ curl -H 'Content-Type: application/json' -H 'Accept: application/json' -X PUT -d '{"name": "Kyle Boss"}' 
http://comment-api.us-west-2.elasticbeanstalk.com/authors/1`

```
{
    "id": 1,
    "name": "Kyle Boss",
    "created_at": "2018-01-31T03:54:40.000Z",
    "updated_at":"2018-01-31T04:22:49.000Z"
}
```

### Create
Create a new author by POSTing to /authos

`$ curl -H 'Content-Type: application/json' -H 'Accept: application/json' -X POST -d '{"name": "John Smith"}' 
http://comment-api.us-west-2.elasticbeanstalk.com/authors/`

```
{
    "id": 7,
    "name": "John Smith",
    "created_at": "2018-01-31T04:24:53.000Z",
    "updated_at": "2018-01-31T04:24:53.000Z"
}
```

### Destroy
Remove authors by using the DELETE HTTP method.

`$ curl -H 'Content-Type: application/json' -H 'Accept: application/json' -X DELETE 
http://comment-api.us-west-2.elasticbeanstalk.com/authors/7`

### Deactivate Comments
An extra route has been added for comments, which will be available through the PUT/PATCH methods. It takes in an ID
and will update the is_active column to false.

`$ curl -H 'Content-Type: application/json' -H 'Accept: application/json' -X PUT
http://comment-api.us-west-2.elasticbeanstalk.com/deactivate/7`

```
{
    "id": 7,
    "is_active": false,
    "doctor_id": 3,
    "author_id": 1,
    "body": "Just testing",
    "rating": 1,
    "created_at": "2018-01-31T03:55:32.000Z",
    "updated_at": "2018-01-31T04:33:58.000Z"
}
```

### Create Comments
The requirements have dictated that it would be helpful to receive doctor recommendations. The API will also return the
created comment.

`$ curl -H 'Content-Type: application/json' -H 'Accept: application/json' -X POST -d '{"doctor_id": 3, "author_id": 1, 
"rating": 1, "body": "Just testing"}' http://comment-api.us-west-2.elasticbeanstalk.com/comments`

```
{
    "comment": {
        "id": 8,
        "doctor_id": 3,
        "body": "Just testing",
        "rating": 1,
        "author_id": 1,
        "is_active": true,
        "created_at": "2018-01-31T04:39:17.000Z",
        "updated_at":"2018-01-31T04:39:17.000Z"
    },
    "recommendations": [
        {
            "average_rating": "4.0",
            "distance": 88.84074681106834,
            "doctor_name": "Doctor 2",
            "doctor_id": 2
        }
    ]
}
```

### Authors
A person who writes  a comment. Has many comments.

#### Attributes
| Title | Type   |
| ----- | ------ |
| name  | string |

### Comments
A rating of approval or dis-approval for a doctor, written by an author. It is accompanied by a body of text which
explains why this rating was given. They can be de-activated.

#### Attributes
| Title     | Type    |
| --------- | ------- |
| doctor_id | bigint  |
| body      | text    |
| rating    | integer |
| author_id | bigint  |
| is_active | boolean |

### Doctors
The subject of the Comments. Doctors belong to a group, and has many specialties. There are indices on the latitude and
longitude to speed up calculations on distance.

#### Attributes
| Title          | Type    |
| -------------- | ------- |
| group_id       | bigint  |
| name           | string  |
| street_address | string  |
| city           | string  |
| state          | string  |
| latitude       | decimal |
| longitude      | decimal |

### DoctorsSpecialty
A mapping table to provide a has_many relationship from Doctors to Specialties.

#### Attributes
| Title        | Type   |
| ------------ | ------ |
| doctor_id    | bigint |
| specialty_id | bigint |

### Groups
A conglomerate of doctors. Each group can have many doctors.

#### Attributes
None.

### Specialties
An area of expertise for a Doctor.

#### Attributes
| Title | Type   |
| ----- | ------ |
| name  | string |

### Recommendations (Model only -- No controller provided)
A single recommendation represents a doctor who is similar to another doctor. There are four important pieces of 
information that is looked at when a Recommendation is created between two doctors: Does the recommended doctor have a 
high rating? Is the recommended doctor close by to the other doctor? Does the recommended doctor share specialties with
the other doctor? Are the doctors a part of the same group?

Each one of the following factors will contribute to one-fourth of the "recommendability score". Doctors will be sorted
by recommendability score relative to a base doctor, and the top ones will be recommended.

#### Rating
The average rating will be calculated. Ratings have values of 1-5. Only the last 100 ratings will be considered in the
average. This design decision was made because a lot of folks care more about trends than absolute figures. If the
doctor is amazing, but made a lot of mistakes 10 years ago, they should be prefered over folks who make a lot of
mistakes now, but were awesome last year. Deactivated ratings will not be considered.

#### Distance
The distance between the recommended doctor and a base doctor is normalized, and squished into a score of 1-5. 

#### Shared Specialties
The number of specialties shared between the two doctors will be considered. The score will be 0-5. 0 if the doctors
share 0 specialties, 2 if the doctors share 2 specialties, etc. -- up to 5. At 5 shared specialties the score caps out
so that it does not dominate over the other two factors. 

#### Group
If doctors are a part of the same group, they might be considered similar and thus recommended. If the doctors are a
part of the same group, a score of 5 will be provided, 0 otherwise.

#### Final Recommendability score:

`Rating + Distance + Specialties + Group = Score`

## Things to consider
There are things that have not been coded in, but should be thought about for further consideration.

### Profanity Filtering
We don't want profanity to get through on the comments. How could we handle it?

#### Obscenity Gem
To be quite honest, I would probably just use the [obscenity gem](https://github.com/tjackiw/obscenity). 

#### Report Button
Also, I would probably be hesitant because humans are incredibly clever. This 
[StackOverflow response](https://stackoverflow.com/a/13362107/7863279) demonstrates why attempting to filter profanity
might be a lost-cause. A "Report" button might be the most efficient way... 

#### Offline Queuing/Cleansing System
But, let's say we really *did* want to implement a profanity filter, how would we do this? We probably would want to do
this offline. We don't want to make the user wait because we are doing complicated regexes over long strings. 

Maybe once the user submits a comment, we insert it into a queue (think API Gateway -> SQS -> Lambda -> RDS). The 
comment won't be immediately visible & there will be a bit of extra over-head in terms of cost & infrastructure, but we 
can rejoice that our text will be cleansed of any bad words. 

Again though, it is important to keep in mind what Brian said above about how complicated a regex would have to be to 
beat the clever humans while not accidentally removing non-profanity.

### Security and Authentication
We do not want authors to be able to alter other authors comments, or any unauthorized users to add or remove doctors.
How do we protect the API, and give only those users who need access to certain calls those privileges?

#### Session Keys
We could use session keys. These keys could be stored in a database that map to a user. Users could have a certain
authentication level, granting them access to particular things. These session keys would need to be passed into the
URL, and a system would need to be set in place to deactive these keys.

### Admin Approval
What if we needed admin approval for comments? What infrastructure would we add?

#### Reversing the default is_active property
The is_active property essentially turns a comment "off". At the moment, it defaults to true, meaning all comments will
automatically be visible until they are turned off. An admin-approval process would essentially require the opposite:
For all comments to be invisible until they are turned on. If is_active is set to default, an admin would go through all
the comments (sorted by time), and set is_active is true to all of the comments she'd like to approve.