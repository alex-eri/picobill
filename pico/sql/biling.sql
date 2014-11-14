CREATE TABLE account (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	account varchar(16) NOT NULL,
	balance NUMERIC NOT NULL default 0,
	limit NUMERIC NOT NULL default 0
);
CREATE INDEX account_account ON account(account);

CREATE TABLE service (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        service varchar(16) NOT NULL,
        cost NUMERIC NOT NULL default 0,
        inclusion_cost NUMERIC NOT NULL default 0,
        period INTEGER
);
CREATE INDEX service_name ON service(service);

CREATE TABLE user (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
	account varchar(16) NOT NULL,
	username varchar(64) NOT NULL default ''                
);
CREATE INDEX user_account ON user(account);
CREATE INDEX user_name ON user(username);

CREATE TABLE userservice (
	username varchar(64) NOT NULL default ''   ,             
        service varchar(16) NOT NULL,
        enabled BOOLEAN default TRUE
);
CREATE INDEX userservice_user ON userservice(username);
CREATE INDEX userservice_service ON userservice(service);
CREATE INDEX userservice_enabled ON userservice(enabled);

CREATE TABLE fiscal (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
	account varchar(16) NOT NULL,
        uuid varchar(64) NOT NULL ,
        type INTEGER NOT NULL default 0,
        ammount NUMERIC NOT NULL default 0
);
CREATE INDEX fiscal_account ON fiscal(account);
