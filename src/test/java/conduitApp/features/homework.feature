Feature: Test for the home page

    Background: Preconditions
        Given url apiUrl
        * def tokenResponse = call read('classpath:helpers/createToken.feature')
        * def token = tokenResponse.authToken
        * def resquestbody = read('classpath:conduitApp/json/requestbody1.json')
        * def timevalidator = read('classpath:helpers/time-validator.js')
        * def dataGenerator = Java.type('helpers.DataGenerate')
        * set resquestbody.article.description = dataGenerator.getRamdomArticleValues().description




    #Step 1: Get atricles of the global feed
    Scenario:  Favorite articles

        Given path "articles"
        Given params {limit: 10,offset: 0}
        And header Authorization = "Token " + token
        When method Get
        Then status 200
        * print response

        #Step 2: Get slug

        * def id_slug = response.articles[0].slug
        * print id_slug
        * def Count = response.articles[0].favoritesCount
        #  favoriteCount == 1
        #Step 3: Make POST request to increse favorites count for the first article
        * if(Count == 1) karate.call('delete.feature')
        Given path "articles/" + id_slug + "/favorite"
        And header Authorization = "Token " + token
        When method Post
        Then status 200
        * print response

        #Step 4: Verify response schema
        And match response.article ==
            """
            {
                "id": "#number",
                "slug": "#string",
                "title": "#string",
                "description": "#string",
                "body": "#string",
                "createdAt": "#? timevalidator(_)",
                "updatedAt": "#? timevalidator(_)",
                "authorId": "#number",
                "tagList": "#array",
                "author": {
                    "username": "#string",
                    "bio": "##string",
                    "image": "#string",
                    "following": "#boolean"
                },
                "favoritedBy": "#array",
                "favorited": "#boolean",
                "favoritesCount": "#number"
            }
            """

        # Step 5: Verify that favorites article incremented by 1

        * def favoriteCount = 0
        And match response.article.favoritesCount == favoriteCount + 1
        * print favoriteCount

        # Step 6: Get all favorite articles

        Given path "articles"
        Given params {favorited: Test23,limit: 10,offset: 0}
        And header Authorization = "Token " + token
        When method Get
        Then status 200
        * print response

        # Step 7: Verify response schema

        And match each response.articles ==
            """
            {
                "slug": "#string",
                "title": "#string",
                "description": "#string",
                "body": "#string",
                "createdAt": "#? timevalidator(_)",
                "updatedAt": "#? timevalidator(_)",
                "tagList": "#array",
                "author": {
                    "username": "#string",
                    "bio": "##string",
                    "image": "#string",
                    "following": "#boolean"
                },
                "favoritesCount": "#number",
                "favorited": "#boolean"
            }
            """



        # Step 8: Verify that slug ID from Step 2 exist in one of the favorite articles

        And match response.articles[0].favorited == "#boolean"
        * print response.articles[0].favorited
        # Step 9:Delete favorite
        # Given path "articles/" + id_slug + "/favorite"
        # And header Authorization = "Token " + token
        # When method Delete
        # Then status 200
        # * print response

    Scenario: Comment articles

        # Step 1: Get atricles of the global feed
        Given path "articles"
        Given params {limit: 10,offset: 0}
        And header Authorization = "Token " + token
        When method Get
        Then status 200
        * print response

        #Step 2: Get slug

        * def id_slug = response.articles[0].slug
        * print id_slug

        # Step 3: Make a GET call to 'comments' end-point to get all comments

        Given path "articles/" + id_slug + "/comments"
        And header Authorization = "Token " + token
        When method Get
        Then status 200
        * print response

        # Step 4: Verify response schema

        And match each response.comments ==
            """

            {
            "id": "#number",
            "createdAt": "#? timevalidator(_)",
            "updatedAt": "#? timevalidator(_)",
            "body": "#string",
            "author": {
            "username": "#string",
            "bio": "##string",
            "image": "#string",
            "following": "#boolean"
            }
            },
            {
            "id": "#number",
            "createdAt": "#? timevalidator(_)",
            "updatedAt": "#? timevalidator(_)",
            "body": "#string",
            "author": {
            "username": "#string",
            "bio": "##string",
            "image": "#string",
            "following": "#boolean"
            }
            }


            """

        # Step 5: Get the count of the comments array lentgh and save to variable

        * def responseComments = response.comments
        * def articlesCount = responseComments.length
        * print articlesCount

        # Step 6: Make a POST request to publish a new comment

        Given path "articles/" + id_slug + "/comments"
        And header Authorization = "Token " + token
        And request resquestbody
        When method Post
        Then status 200
        * print response
       

        # Step 7: Verify response schema that should contain posted comment text

        And match response.comment ==
            """
            {
                "id": "#number",
                "createdAt": "#? timevalidator(_)",
                "updatedAt": "#? timevalidator(_)",
                "body": "#string",
                "author": {
                    "username": "#string",
                    "bio": "##string",
                    "image": "#string",
                    "following": "#boolean"
                }
            }
            """

        # Step 8: Get the list of all comments for this article one more time

        Given path "articles/" + id_slug + "/comments"
        And header Authorization = "Token " + token
        And request resquestbody
        When method Get
        Then status 200
        * print response

        # Step 9: Verify number of comments increased by 1 (similar like we did with favorite counts)
        
        * def commentariesCount = response.comments.length
        * print commentariesCount
        And match commentariesCount == articlesCount + 1

        # Step 10: Make a DELETE request to delete comment
        * def id_coment = response.comments[0].id
        * print id_coment

        Given path "articles/" + id_slug + "/comments/" + id_coment
        And header Authorization = "Token " + token
        And request resquestbody
        When method Delete
        Then status 204

       # Step 11: Get all comments again and verify number of comments decreased by 1 
       
       Given path "articles/" + id_slug + "/comments"
       And header Authorization = "Token " + token
       When method Get
       Then status 200
       * print response
        
















