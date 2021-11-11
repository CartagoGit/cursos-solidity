// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

string constant api = "https://api.nasa.gov/neo/rest/v1/feed?start_date=START_DATE&end_date=END_DATE&api_key=API_KEY";
contract Oracle {
  constructor() {
    owner = msg.sender;
  }

  address owner;
}
