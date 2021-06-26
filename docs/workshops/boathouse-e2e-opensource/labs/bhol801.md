# BHOL801 - 接口测试生命周期管理

## demo 1 - add swagger ui into node.js express

git clone git@github.com:idcf-boat-house/boathouse-sampleapi.git

1. add swagger.json
2. update server.js

```javascript
// line 9
const swaggerUi = require('swagger-ui-express'),
    swaggerDocument = require('./swagger.json');

// before app.listen
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument));
```

3. start the application and open http://localhost:3000/api-docs/

```shell
npm install
npm start
```

## demo 2 - use postman to test boathouse-calculator

open postman

1. add new collection boathouse-calcuator-tests
2. add api requests and run the requests
    - adds two positive integers {{host}}/arithmetic?operation=add&operand1=21&operand2=21
    - adds zero to an integer {{host}}/arithmetic?operation=add&operand1=42&operand2=0
3. add the following tests

```javascript
//adds two positive integers
pm.test("Status code is 200", function () {
    pm.response.to.have.status(200);
});

pm.test("Should reture 42", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData.result).to.eql('42');
});

//adds zero to an integer
pm.test("Status code should be 200", function(){
    pm.response.to.have.status(200);
});

pm.test("Expected result should be 42", ()=>{
    const reponseJson = pm.response.json();
    pm.expect(reponseJson.result).to.eql(42);
});

```

## 03 - Run postman collections with newman

```shell
# install newman to run postman collections in command line https://www.npmjs.com/package/newman
npm install -g newman
# install newman-reporter-junit to export test report in juntest format https://www.npmjs.com/package/newman-reporter-junitfull
npm install -g newman-reporter-junitfull

## newman sample command
newman run postman/boathouse-calculator.postman_collection.json -e postman/local-dev.postman_environment.json

## newman sample command with junit report export
newman run postman/boathouse-calculator.postman_collection.json -e postman/local-dev.postman_environment.json -r junitfull --reporter-junitfull-export './postman/result.xml' -n 2
```

```shell
## run newman using the newman docker container
docker run -v "${PWD}/postman:/etc/newman" -t postman/newman:alpine run boathouse-calculator.postman_collection.json -e local-dev.postman_environment.json
## with junit format report 
docker run -v "${PWD}/postman:/etc/newman" -t postman/newman:alpine run boathouse-calculator.postman_collection.json -e local-dev.postman_environment.json --reporters junit --reporter-junit-export 'result-docker.xml'
```

## 04 - Run postman collections with newman

update Jenkinsfile

```Jenkinsfile
        stage ('API Testing - Postman'){
            steps {
                        warnError('Testing Failed'){
                            sh 'docker run --rm -v "${PWD}/postman:/etc/newman" -t postman/newman:alpine run boathouse-calculator.postman_collection.json -e local-dev.postman_environment.json --reporters junit --reporter-junit-export "result-docker.xml"'
                        }
                        
                    }
                    post {
                        always{
                            echo "upload test results ..."
                            junit 'postman/*.xml'
                        }                
                    }
                    
        }
```

## 05 - Contract Testing with Pact



