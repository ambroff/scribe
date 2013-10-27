#!/usr/local/bin/thrift --gen cpp:pure_enums --gen php

##  Copyright (c) 2007-2008 Facebook
##
##  Licensed under the Apache License, Version 2.0 (the "License");
##  you may not use this file except in compliance with the License.
##  You may obtain a copy of the License at
##
##      http://www.apache.org/licenses/LICENSE-2.0
##
##  Unless required by applicable law or agreed to in writing, software
##  distributed under the License is distributed on an "AS IS" BASIS,
##  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##  See the License for the specific language governing permissions and
##  limitations under the License.
##
## See accompanying file LICENSE or visit the Scribe site at:
## http://developers.facebook.com/scribe/

namespace cpp scribe.thrift
namespace java scribe.thrift
namespace perl Scribe.Thrift

enum ResultCode
{
  OK,
  TRY_LATER
}

enum Status {
  DEAD = 0,
  STARTING = 1,
  ALIVE = 2,
  STOPPING = 3,
  STOPPED = 4,
  WARNING = 5,
}

struct LogEntry
{
  1:  string category,
  2:  string message
}

service scribe
{
  /**
   * Send a list of log entries to this server. If the operation is successful,
   * this function will respond with OK. TRY_LATER means that the entire list
   * should be sent again.
   */
  ResultCode Log(1: list<LogEntry> messages);

  /**
   * Returns the version of the service
   */
  string getVersion(),

  /**
   * Gets the status of this service
   */
  Status getStatus(),

  /**
   * User friendly description of status, such as why the service is in
   * the dead or warning state, or what is being started or stopped.
   */
  string getStatusDetails(),

  /**
   * Gets the value of a single counter
   */
  map<string, i64> getCounters(),

  /**
   * Gets the counters for this service
   */
  i64 getCounter(1: string key),

  /**
   * Sets an option
   */
  void setOption(1: string key),

  /**
   * Gets an option
   */
  void getOption(1: string key),

  /**
   * Gets all options
   */
  map<string, string> getOptions(),

  /**
   * Returns the unix time that the server has been running since
   */
  i64 aliveSince(),

  /**
   * Tell the server to reload its configuration, reopen log files, etc
   */
  oneway void reinitialize(),

  /**
   * Suggest a shutdown to the server
   */
  oneway void shutdown()
}
