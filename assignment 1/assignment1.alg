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

qSongsInTimeFrameWRating3 :=
	project songCode (select  rating =3 (qSongsBetween1990And2000));

qSongsComposedBy :=
	composedOf njoin (qSongsInTimeFrameWRating3 njoin song);

qSongsOnCD :=
	qSongsComposedBy njoin cd;

answer2 :=
	project songTitle, groupCode, groupName (qSongsOnCD njoin musicalGroup);

%---------------------------------%
%           Problem 3             %
%---------------------------------%
% List songs in CDs that were 
% rented by clients who live in 
% ‘Los Angeles’ and (CDs)
% were published in 1998.
% (attributes to retrieve: songTitle, 
% clientID, firstName, lastName)
qCDsFrom1998 :=
	project cdCode (select year=1998 (cd));

qSongsFromCDsFrom1998 :=
	composedOf njoin qCDsFrom1998;

qSongTitlesFromCDsFrom1998 :=
	project cdCode, songTitle (song njoin qSongsFromCDsFrom1998);

qSongTitlesFrom1998RentedBy :=
	project clientID, songTitle (rentedBy njoin qSongTitlesFromCDsFrom1998);

qClientsWhoLiveInLA :=
	select address='Los Angeles' (client);

answer3 :=
	project clientID, firstName, lastName, songTitle (qClientsWhoLiveInLA njoin qSongTitlesFrom1998RentedBy);

%---------------------------------%
%           Problem 4             %
%---------------------------------%
% List artists who have been 
% a member of only one group.
% (attributes to retrieve: artistID, firstName, lastName)
qMember:=
	project artistID, groupCode (member);

qRenameMember(aid, gid) :=
	project artistID, groupCode (member);

qTest := 
	select groupCode <> gid and artistID = aid (qMember njoin qRenameMember);
%---------------------------------%
%           Problem 5             %
%---------------------------------%
% List CDs whose musical group 
% has at least one member who 
% was born after 1970 (1970 is inclusive)
% (attributes to retrieve: cdCode, groupCode, groupName)
