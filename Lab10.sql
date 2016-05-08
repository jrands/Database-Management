
--PreReqsFor

create or replace function PreReqsFor(int, REFCURSOR) returns refcursor as
$$
declare
  classNum int:= $1;
  resultset REFCURSOR:= $2;
begin
  open resultset for
    select prereqnum 
    from Prerequisites
    where coursenum = classNum;
  return resultset;
end;
$$
language plpgsql;


--isPreReqFor
create or replace function isPreReqFor(int, REFCURSOR) returns refcursor as
$$
declare
  classNum int:= $1;
  resultset REFCURSOR:= $2;
begin
  open resultset for
    select coursenum 
    from Prerequisites
    where prereqnum = classNum;
  return resultset;
end;
$$
language plpgsql;