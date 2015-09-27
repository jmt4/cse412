% Name: James Triphahn
% Email: jtriphah@asu.edu
% Class: CSE 412 Database Management
% Professor: Dr. Nakamura
% Date: October 1, 2015

%--------------------------------------------------------------------%
%                          Data - Tuples                             %
%--------------------------------------------------------------------%
% client(clientID, firstName, lastName, phone, address)              %
% artist(artistID, firstName, lastName, yearBorn)                    %
% musicalGroup(groupCode, groupName)                                 %
% member(artistID, groupCode, fromDate, toDate)                      %
% cd(cdCode, cdTitle, year, numberSold, groupCode)                   %
% availableCopy(cdCode, seqNum)                                      %
% rentedBy(cdCode, seqNum, clientID, fromDate, toDate, pricePerDay)  %
% song(songCode, songTitle)                                          %
% composedOf(cdCode, songCode, trackNumber)                          %
% writtenBy(songCode, artistID)                                      %
% topCDs(cdCode, year, rating)                                       %
% topSongs(songCode, year, rating)                                   %
%--------------------------------------------------------------------%


%---------------------------------%
%           Problem 1             %
%---------------------------------%
% Query : Clients who rented CDs 
% containing a song titled "Goodnight"
% or who live in Phoenix (hint: union)
qSongCodeForGoodnight :=
	select songTitle='Goodnight' (song);

qCDsWithSongCode :=
	composedOf njoin qSongCodeForGoodnight;

qClientsRentedCD :=
	project clientID (qCDsWithSongCode njoin rentedBy);

qClientsInPhx :=
	project clientID (select address='Phoenix' (client));

answer1 :=
	qClientsInPhx union qClientsRentedCD;

%---------------------------------%
%           Problem 2             %
%---------------------------------%
% Query : List musical groups 
% whose songs were at the top 3 
% (topSongs.rating=3) between the
% year 1990 and 2000. (attributes to 
% retrieve: groupCode, groupName, 
% and songTitle)
qSongs1990AndAfter :=
	select year >= 1990 (topSongs);

qSongsBetween1990And2000 :=
	select year <= 2000 (qSongs1990AndAfter);

qSongsInTimeFrameWRating3OrAbove :=
	project songCode (select  rating <=3 (qSongsBetween1990And2000));

qSongsWrittenBy :=
	writtenBy njoin (qSongsInTimeFrameWRating3OrAbove njoin song);

qMemberWroteSong :=
	qSongsWrittenBy njoin member;

answer2 :=
	project songTitle, groupCode, groupName (qMemberWroteSong njoin musicalGroup);

%---------------------------------%
%           Problem 3             %
%---------------------------------%

%---------------------------------%
%           Problem 4             %
%---------------------------------%

%---------------------------------%
%           Problem 5             %
%---------------------------------%