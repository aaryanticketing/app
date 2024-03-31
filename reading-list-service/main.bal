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

type Movie record {|
    string id;
    string movie_name;
    string description_text;
    string image;
    string start_date;
    string end_date;
    string amount;
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

type Ticket record {|
    string id;
    string user_id;
    string show_id;
    string qty;
    string movie_id;
    string amount;
|};


@http:ServiceConfig {
    cors: {
        allowOrigins: ["*"],
        allowMethods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
        allowCredentials: false,
        allowHeaders: ["authorization","Access-Control-Allow-Origin","Content-Type","SOAPAction","apikey","Internal-Key"],
        exposeHeaders: ["X-CUSTOM-HEADER"],
        maxAge: 84900
    }
}
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

    resource function get show/[string movieId]/[string locationId]/[string timeId]/[string dateSelected]() returns Show[]|error {
        stream<Show, sql:Error?> showStream = self.db->query(`SELECT * FROM shows where movie_id=${movieId} AND location_id=${locationId} AND time_id=${timeId} AND date_selected=${dateSelected}`);
        return from Show show in showStream select show;
    }

    resource function put show(@http:Payload Show show) returns Show|error {
        if show.id == "" {
            string uuid1 = uuid:createType1AsString();
            show.id = uuid1;    
        }

        _ = check self.db->execute(`
           INSERT INTO shows (id, movie_id, date_selected, time_id, seats_left, location_id)
            VALUES(${show.id}, ${show.movie_id}, ${show.date_selected}, ${show.time_id}, ${show.seats_left}, ${show.location_id})
            ON DUPLICATE KEY UPDATE movie_id=${show.movie_id}, date_selected=${show.date_selected},
            time_id=${show.time_id}, seats_left=${show.seats_left}, location_id=${show.location_id};`);
        return show;
    }

    resource function post ticket(@http:Payload Ticket ticket) returns Ticket|error {
        string uuid1 = uuid:createType1AsString();
        ticket.id = uuid1;    
        _ = check self.db->execute(`
           INSERT INTO ticket (id, user_id, show_id, qty, movie_id, amount)
            VALUES(${ticket.id}, ${ticket.user_id}, ${ticket.show_id}, ${ticket.qty}, ${ticket.movie_id}, ${ticket.amount});`);
        return ticket;
    }
}