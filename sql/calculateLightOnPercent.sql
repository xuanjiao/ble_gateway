-- create a new table
-- set global sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
-- set session sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
SET collation_connection = 'utf8_general_ci';
use light_db;
drop table if exists light_on_percent;
create table light_on_percent(timeslot varchar(20), light_on_percent float(4,2));


-- create a proceture that calculate light on percent and insert it into a new table
drop procedure if exists getLightOnPercentAtDay;
delimiter |
create procedure getLightOnPercentAtDay(day_of_week varchar(10), hour_min int , hour_max int)
begin
	insert into light_on_percent(timeslot, light_on_percent)
	select concat(dayname(date_time),' ',hour_min,'-',hour_max ) as timeslot,
			sum(case when light > 40 then 1
                else 0
                end
                )/count(*)*1.0 as light_on_percent
	from light_list
	where HOUR(date_time) > hour_min and HOUR(date_time) < hour_max and dayname(date_time) = day_of_week;
end|

delimiter ;

-- call getLightOnPercentAtDay('Monday',8,10);

call getLightOnPercentAtDay('Monday',10,12);
call getLightOnPercentAtDay('Monday',12,14);
call getLightOnPercentAtDay('Monday',14,16);
call getLightOnPercentAtDay('Monday',16,18);

select * from light_on_percent;
