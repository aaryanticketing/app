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
    string start_date;
    string end_date;
|};

type LocationTime record {|
    string location_id;
    string time_id;
    string times;
    string loc_name;
    string address;
    string seats;
|};

type Show record {|
    string id;
    string movie_id;
    string date_selected;
    string time_id;
    string seats_left;
    string location_id;
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

    resource function get locationTimes() returns LocationTime[]|error {
        stream<LocationTime, sql:Error?> locationTimeStream = self.db->query(`SELECT location.id as location_id, times.id as time_id, times.times as times, location.loc_name, location.address, location.seats FROM location LEFT JOIN times ON location.time_id = times.id`);
        return from LocationTime locationTime in locationTimeStream select locationTime;
    }

    resource function get show/[string movieId]/[string locationId]/[string timeId]() returns Show[]|error {
        stream<Show, sql:Error?> showStream = self.db->query(`SELECT * FROM shows where movie_id = '${movieId}' AND location_id = '${locationId}' AND time_id = '${timeId}'`);
        return from Show show in showStream select show;
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