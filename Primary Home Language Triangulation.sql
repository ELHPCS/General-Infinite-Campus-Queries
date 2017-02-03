--Household Contact language for all students enrolled as of Oct 5, even inactive.
--Until we get families to fill out the primary language field, we are looking to see if one household guardian with the mailing flag prefers Spanish.  If so, we mark the family as Spanish speaking.

select s.studentNumber
	, s.lastName
	, s.firstName
	, s.grade
	, sch.name
	, s.endDate
	, np.value as [Attending School ID]
	, case when sum(case when ct.communicationLanguage = 'es_MX' then 1 else 0 end) > 0 then 'Spanish' else 'English' end as primaryLang
	
from
student s
left join v_CensusContactSummary ccs ON ccs.personid = s.personid and ccs.mailing=1 and ccs.relatedBy='household' and relationship <> 'self' and ccs.guardian=1 
left join contact ct on ct.personID=ccs.contactPersonID
left join customstudent np on np.enrollmentID=s.enrollmentID and np.attributeID=573 --ELH's attribute ID for nonpublic students
join school sch on sch.schoolID=s.schoolID
where s.activeYear=1 and s.serviceType='P' and (s.endDate is null or s.endDate >= cast('10/5/2016' as dateTime)) -- show students that were enrolled as of Oct 5th
group by
s.studentNumber
	, s.lastName
	, s.firstName
	, s.grade
	, sch.name
	, s.endDate
	, np.value


