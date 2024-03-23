import ballerina/http;
import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;
import ballerina/uuid;

configurable string host = ?;
configurable int port = ?;
configurable string user_name_db = ?;
configurable string password = ?;
configurable string database = ?;

type User record {|
    string email;
    string user_type;
    string id;
    string user_name;
|};

type Movie record {|
    string id;
    string movie_name;
    string description_text;
    string image;
    string  start_date;
    string end_date;
|};

service / on new http:Listener(8080) {
    private final mysql:Client db;

    function init() returns error? {
        self.db = check new (host, user_name_db, password, database, port);
    }

    resource function get movies() returns Movie[]|error {

        stream<Movie, sql:Error?> movieStream = self.db->query(`SELECT * FROM Movie`);
        return from Movie movie in movieStream select movie;
    }

    resource function get users/[string id]() returns User|http:NotFound|error {
        User|sql:Error result = self.db->queryRow(`SELECT * FROM Users WHERE id = ${id}`);
        if result is sql:NoRowsError {
            return http:NOT_FOUND;
        } else {
            return result;
        }
    }

    resource function post users(@http:Payload User user) returns User|error {
        string uuid1 = uuid:createType1AsString();
        user.id = uuid1;
        _ = check self.db->execute(`
            INSERT INTO Users (id, user_type, email, user_name)
            VALUES (${user.id}, ${user.user_type}, ${user.email}, ${user.user_name});`);
        return user;
    }
}