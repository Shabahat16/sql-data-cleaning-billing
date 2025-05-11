-- Finding Duplicates:

select *, count(*) 
from billing_data 
group by invoice_id, customer_name, billing_date, amount_billed, amount_paid, payment_status 
having count(*) > 1

-- Deleting Duplicates:

delete from billing_data a
using (
     select min(ctid) as ctid, invoice_id, customer_name, billing_date, 
	 amount_billed, amount_paid, payment_status
	 from billing_data
	 group by invoice_id, customer_name, billing_date, amount_billed, 
	 amount_paid, payment_status
	 having count(*) >1
) b 
where a.invoice_id = b.invoice_id 
and   a.customer_name = b.customer_name 
and   a.billing_date = b.billing_date
and   a.amount_billed = b.amount_billed
and   a.amount_paid = b.amount_paid
and   a.payment_status = b.payment_status 
and   a.ctid <> b.ctid

--Checking for Null or Missing Values:

select * from billing_data where invoice_id is null 
or customer_name is null 
or billing_date is null 
or amount_billed is null 
or amount_paid is null
or payment_status is null

-- Updating Null values:

update billing_data 
set payment_status = 'Paid'
where payment_status is null
and cast(amount_billed as double precision) = amount_paid

update billing_data 
set payment_status = 'Pending'
where payment_status is null 
and cast(amount_billed as double precision) > amount_paid

update billing_data 
set amount_paid = cast(amount_billed as double precision)
where amount_paid is null
and amount_billed is not null
and payment_status = 'Paid'

update billing_data
set payment_status = 'Pending'
where payment_status is null
and amount_paid is null
and cast(amount_billed as double precision) is not null

update billing_data
set amount_paid = 0
where amount_paid is null
and payment_status = 'Pending'

update billing_data
set amount_paid = 0
where payment_status = 'Overdue'
and amount_paid is null
Correcting some unknown values:
select * from billing_data
where amount_billed = 'unknown'

update billing_data
set amount_billed = cast(amount_paid as text)
where payment_status = 'Paid'
and amount_billed = 'unknown'

-- Changing Data Type:

alter table billing_data
alter column amount_billed
type numeric 
using amount_billed :: numeric

alter table billing_data
alter column amount_paid
type numeric 
using amount_paid :: numeric

--OR

Alter table billing_data
Alter column amount_billed
Type numeric
Using amount_billed :: numeric
Alter column amount_paid
Type numeric
Using amount_paid :: numeric 

--Standardizing Data:

update billing_data
set amount_billed = round(amount_billed, 2),
    amount_paid = round(amount_paid, 2)

