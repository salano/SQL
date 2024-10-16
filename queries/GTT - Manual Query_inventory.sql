select 
	'2021-09-01 00:00:00' as OpeningDate,
	'2021-10-01 00:00:00' as ClosingDate,
	tb6.BranchCode,
	tb6.BranchName,
	tb7.BranchItemLocation,
	tb6.ItemNumber,
	tb6.ItemName,
	tb6.ItemCategory,
	tb7.location_qty as current_qty,
	tb7.location_cost as current_cost,
	tb7.location_qty + (if(isnull(tb3.total_qty_out), 0, tb3.total_qty_out)) - (if(isnull(tb4.total_qty_in), 0, tb4.total_qty_in)) as SystemCalculatedClosingQty,
	tb7.location_cost + (if(isnull(tb3.total_cost_out), 0, tb3.total_cost_out)) - (if(isnull(tb4.total_cost_in), 0, tb4.total_cost_in)) as SystemCalculatedClosingCost,
	tb7.location_qty + (if(isnull(tb3.total_qty_out), 0, tb3.total_qty_out)) - (if(isnull(tb4.total_qty_in), 0, tb4.total_qty_in)) + (if(isnull(tb1.total_qty_out), 0, tb1.total_qty_out)) - (if(isnull(tb2.total_qty_in), 0, tb2.total_qty_in)) as SystemCalculatedOpeningQty,
	tb7.location_cost + (if(isnull(tb3.total_cost_out), 0, tb3.total_cost_out)) - (if(isnull(tb4.total_cost_in), 0, tb4.total_cost_in)) + (if(isnull(tb1.total_cost_out), 0, tb1.total_cost_out)) - (if(isnull(tb2.total_cost_in), 0, tb2.total_cost_in)) as SystemCalculatedOpeningCost,
	if(isnull(tb1.total_qty_out), 0, tb1.total_qty_out) as Total_qty_out,
	if(isnull(tb1.total_cost_out), 0, tb1.total_cost_out) as Total_cost_out,
	if(isnull(tb1.Sale_qty), 0, tb1.Sale_qty) as Sale_qty,
	if(isnull(tb1.Sale_cost), 0, tb1.Sale_cost) as Sale_cost,
	if(isnull(tb1.ExchangeOut_qty), 0, tb1.ExchangeOut_qty) as ExchangeOut_qty,
	if(isnull(tb1.ExchangeOut_cost), 0, tb1.ExchangeOut_cost) as ExchangeOut_cost,
	if(isnull(tb1.LoanOut_qty), 0, tb1.LoanOut_qty) as LoanOut_qty,
	if(isnull(tb1.LoanOut_cost), 0, tb1.LoanOut_cost) as LoanOut_cost,
	if(isnull(tb1.ShelfCountOut_qty), 0, tb1.ShelfCountOut_qty) as ShelfCountOut_qty,
	if(isnull(tb1.ShelfCountOut_cost), 0, tb1.ShelfCountOut_cost) as ShelfCountOut_cost,
	if(isnull(tb1.PurchaseOrderOut_qty), 0, tb1.PurchaseOrderOut_qty) as RMAOutQty,
	if(isnull(tb1.PurchaseOrderOut_cost), 0, tb1.PurchaseOrderOut_cost) as RMAOutCost,
	if(isnull(tb1.StockTransferOut_qty), 0, tb1.StockTransferOut_qty) as StockTransferOut_qty,
	if(isnull(tb1.StockTransferOut_cost), 0, tb1.StockTransferOut_cost) as StockTransferOut_cost,
	if(isnull(tb1.OtherOut_qty), 0, tb1.OtherOut_qty) as OtherOut_qty,
	if(isnull(tb1.OtherOut_cost), 0, tb1.OtherOut_cost) as OtherOut_cost,
	if(isnull(tb2.total_qty_in), 0, tb2.total_qty_in) as Total_qty_in,
	if(isnull(tb2.total_cost_in), 0, tb2.total_cost_in) as Total_cost_in,
	if(isnull(tb2.RefundIn_qty), 0, tb2.RefundIn_qty) as RefundIn_qty,
	if(isnull(tb2.RefundIn_cost), 0, tb2.RefundIn_cost) as RefundIn_cost,
	if(isnull(tb2.VoidIn_qty), 0, tb2.VoidIn_qty) as VoidIn_qty,
	if(isnull(tb2.VoidIn_cost), 0, tb2.VoidIn_cost) as VoidIn_cost,
	if(isnull(tb2.ExchangeIn_qty), 0, tb2.ExchangeIn_qty) as ExchangeIn_qty,
	if(isnull(tb2.ExchangeIn_cost), 0, tb2.ExchangeIn_cost) as ExchangeIn_cost,
	if(isnull(tb2.LoanIn_qty), 0, tb2.LoanIn_qty) as LoanIn_qty,
	if(isnull(tb2.LoanIn_cost), 0, tb2.LoanIn_cost) as LoanIn_cost,
	if(isnull(tb2.ShelfCountIn_qty), 0, tb2.ShelfCountIn_qty) as ShelfCountIn_qty,
	if(isnull(tb2.ShelfCountIn_cost), 0, tb2.ShelfCountIn_cost) as ShelfCountIn_cost,
	if(isnull(tb2.PurchaseOrderIn_qty), 0, tb2.PurchaseOrderIn_qty) as PurchaseOrderIn_qty,
	if(isnull(tb2.PurchaseOrderIn_cost), 0, tb2.PurchaseOrderIn_cost) as PurchaseOrderIn_cost,
	if(isnull(tb2.StockTransferIn_qty), 0, tb2.StockTransferIn_qty) as StockTransferIn_qty,
	if(isnull(tb2.StockTransferIn_cost), 0, tb2.StockTransferIn_cost) as StockTransferIn_cost,
	if(isnull(tb2.OtherIn_qty), 0, tb2.OtherIn_qty) as OtherIn_qty,
	if(isnull(tb2.OtherIn_cost), 0, tb2.OtherIn_cost) as OtherIn_cost
from
	(
		-- current QTY and COST by item, branch, and loc
		select inv_number, branch, 'A' as BranchItemLocation, qty_1 as location_qty, total_cost_1 as location_cost from cin_lcst union ALL
		select inv_number, branch, 'B' as BranchItemLocation, qty_2 as location_qty, total_cost_2 as location_cost from cin_lcst union ALL
		select inv_number, branch, 'C' as BranchItemLocation, qty_3 as location_qty, total_cost_3 as location_cost from cin_lcst union ALL
		select inv_number, branch, 'D' as BranchItemLocation, qty_4 as location_qty, total_cost_4 as location_cost from cin_lcst union ALL
		select inv_number, branch, 'E' as BranchItemLocation, qty_5 as location_qty, total_cost_5 as location_cost from cin_lcst union ALL
		select inv_number, branch, 'F' as BranchItemLocation, qty_6 as location_qty, total_cost_6 as location_cost from cin_lcst union ALL
		select inv_number, branch, 'G' as BranchItemLocation, qty_7 as location_qty, total_cost_7 as location_cost from cin_lcst union ALL
		select inv_number, branch, 'H' as BranchItemLocation, qty_8 as location_qty, total_cost_8 as location_cost from cin_lcst union ALL
		select inv_number, branch, 'I' as BranchItemLocation, qty_9 as location_qty, total_cost_9 as location_cost from cin_lcst union ALL
		select inv_number, branch, 'J' as BranchItemLocation, qty_10 as location_qty, total_cost_10 as location_cost from cin_lcst union ALL
		select inv_number, branch, 'K' as BranchItemLocation, qty_11 as location_qty, total_cost_11 as location_cost from cin_lcst union ALL
		select inv_number, branch, 'L' as BranchItemLocation, qty_12 as location_qty, total_cost_12 as location_cost from cin_lcst union ALL
		select inv_number, branch, 'M' as BranchItemLocation, qty_13 as location_qty, total_cost_13 as location_cost from cin_lcst union ALL
		select inv_number, branch, 'N' as BranchItemLocation, qty_14 as location_qty, total_cost_14 as location_cost from cin_lcst union ALL
		select inv_number, branch, 'O' as BranchItemLocation, qty_15 as location_qty, total_cost_15 as location_cost from cin_lcst union ALL
		select inv_number, branch, 'P' as BranchItemLocation, qty_16 as location_qty, total_cost_16 as location_cost from cin_lcst
	) as tb7 join
	(
		-- base list of ITEM, ITEM CATEGORY, BRANCH
		select 
			cin_lcst.inv_number, 
			csy_mbrc.mbrc_label as BranchCode, 
			csy_mbrc.mbrc_name as BranchName,
			csy_mbrc.mbrc_branch as Branch,
			cin_lcst.inv_number as ItemNumber,
			cin_iven.model_name as ItemName,
			cin_iven.prd_type as ItemCategory
		from 
			cin_lcst join 
			cin_iven on cin_lcst.inv_number = cin_iven.inv_number join 
			csy_mbrc on csy_mbrc.mbrc_branch = cin_lcst.branch
		where 
			cin_iven.open_dept != 'Y' and 
			cin_iven.serial = 'Y'             
	) as tb6 on tb7.inv_number = tb6.inv_number and tb7.branch = tb6.Branch left outer join 
	(
		-- all OUTward movements from a branch within the date range
		select  
			from_branch.mbrc_label as BranchCode, 
			from_branch.mbrc_name as BranchName,
			from_branch.mbrc_branch as Branch,
			cin_hqtx.from_loc as BranchItemLocation,
			cin_hqtx.inv_number as ItemNumber,
			cin_iven.model_name as ItemName,
			cin_iven.prd_type as ItemCategory,
			if(cin_hqtx.from_loc = 'A', cin_lcst.qty_1, if(cin_hqtx.from_loc = 'B', cin_lcst.qty_2, if(cin_hqtx.from_loc = 'C', cin_lcst.qty_3, if(cin_hqtx.from_loc = 'D', cin_lcst.qty_4, if(cin_hqtx.from_loc = 'E', cin_lcst.qty_5, if(cin_hqtx.from_loc = 'F', cin_lcst.qty_6, if(cin_hqtx.from_loc = 'G', cin_lcst.qty_7, if(cin_hqtx.from_loc = 'H', cin_lcst.qty_8, if(cin_hqtx.from_loc = 'I', cin_lcst.qty_9, if(cin_hqtx.from_loc = 'J', cin_lcst.qty_10, if(cin_hqtx.from_loc = 'K', cin_lcst.qty_11, if(cin_hqtx.from_loc = 'L', cin_lcst.qty_12, if(cin_hqtx.from_loc = 'M', cin_lcst.qty_13, if(cin_hqtx.from_loc = 'N', cin_lcst.qty_14, if(cin_hqtx.from_loc = 'O', cin_lcst.qty_15, cin_lcst.qty_16 ))))))))))))))) as current_qty,
			if(cin_hqtx.from_loc = 'A', cin_lcst.total_cost_1, if(cin_hqtx.from_loc = 'B', cin_lcst.total_cost_2, if(cin_hqtx.from_loc = 'C', cin_lcst.total_cost_3, if(cin_hqtx.from_loc = 'D', cin_lcst.total_cost_4, if(cin_hqtx.from_loc = 'E', cin_lcst.total_cost_5, if(cin_hqtx.from_loc = 'F', cin_lcst.total_cost_6, if(cin_hqtx.from_loc = 'G', cin_lcst.total_cost_7, if(cin_hqtx.from_loc = 'H', cin_lcst.total_cost_8, if(cin_hqtx.from_loc = 'I', cin_lcst.total_cost_9, if(cin_hqtx.from_loc = 'J', cin_lcst.total_cost_10, if(cin_hqtx.from_loc = 'K', cin_lcst.total_cost_11, if(cin_hqtx.from_loc = 'L', cin_lcst.total_cost_12, if(cin_hqtx.from_loc = 'M', cin_lcst.total_cost_13, if(cin_hqtx.from_loc = 'N', cin_lcst.total_cost_14, if(cin_hqtx.from_loc = 'O', cin_lcst.total_cost_15, cin_lcst.total_cost_16 ))))))))))))))) as current_cost,
			sum(cin_hqtx.total_qty) as total_qty_out,
			sum(cin_hqtx.total_cost) as total_cost_out,
			sum(if(cin_hqtx.move_type = 'P' and (isnull(cin_hlnk.wcon_id) or tran_header.void_status = 'V'), cin_hqtx.total_qty, 0)) as Sale_qty,
			sum(if(cin_hqtx.move_type = 'P' and (isnull(cin_hlnk.wcon_id) or tran_header.void_status = 'V'), cin_hqtx.total_cost, 0)) as Sale_cost,
			sum(if(cin_hqtx.move_type = 'P' and (cin_hlnk.wcon_id > 0 and tran_header.void_status != 'V'), cin_hqtx.total_qty, 0)) as ExchangeOut_qty,
			sum(if(cin_hqtx.move_type = 'P' and (cin_hlnk.wcon_id > 0 and tran_header.void_status != 'V'), cin_hqtx.total_cost, 0)) as ExchangeOut_cost,
			sum(if(cin_hqtx.move_type = 'M' and cin_hqtx.series_1 != 'S', cin_hqtx.total_qty, 0)) as LoanOut_qty,
			sum(if(cin_hqtx.move_type = 'M' and cin_hqtx.series_1 != 'S', cin_hqtx.total_cost, 0)) as LoanOut_cost,
			sum(if((cin_hqtx.move_type = 'R' and cin_hqtx.series_1 = 'S') or (cin_hqtx.move_type = 'M' and cin_hqtx.series_1 = 'S' and cin_hqtx.series_2 = 'c'), cin_hqtx.total_qty, 0)) as ShelfCountOut_qty,
			sum(if((cin_hqtx.move_type = 'R' and cin_hqtx.series_1 = 'S')  or (cin_hqtx.move_type = 'M' and cin_hqtx.series_1 = 'S' and cin_hqtx.series_2 = 'c'), cin_hqtx.total_cost, 0)) as ShelfCountOut_cost,
			sum(if(cin_hqtx.move_type = 'R' and cin_hqtx.series_1 != 'S', cin_hqtx.total_qty, 0)) as PurchaseOrderOut_qty,
			sum(if(cin_hqtx.move_type = 'R' and cin_hqtx.series_1 != 'S', cin_hqtx.total_cost, 0)) as PurchaseOrderOut_cost,
			sum(if(cin_hqtx.move_type = 'T' or (cin_hqtx.move_type = 'M' and cin_hqtx.series_1 = 'S' and cin_hqtx.series_2 = 't'), cin_hqtx.total_qty, 0)) as StockTransferOut_qty,
			sum(if(cin_hqtx.move_type = 'T' or (cin_hqtx.move_type = 'M' and cin_hqtx.series_1 = 'S' and cin_hqtx.series_2 = 't'), cin_hqtx.total_cost, 0)) as StockTransferOut_cost,
			sum(if(!(cin_hqtx.move_type in ('P','T','R','M')), cin_hqtx.total_qty, 0)) as OtherOut_qty,
			sum(if(!(cin_hqtx.move_type in ('P','T','R','M')), cin_hqtx.total_cost, 0)) as OtherOut_cost
		from 
			cin_hqtx join 
			csy_mbrc from_branch on from_branch.mbrc_branch = cin_hqtx.from_branch join 
			cin_iven on cin_iven.inv_number = cin_hqtx.inv_number left outer join 
			cin_lcst on cin_lcst.inv_number = cin_iven.inv_number and cin_lcst.branch = cin_hqtx.from_branch left outer join 
			cin_hlnk on cin_hlnk.wcon_id = (select wcon_id from cin_hlnk where refund_series = CONCAT(cin_hqtx.series_1, cin_hqtx.series_2) and refund_fol_number = cin_hqtx.fol_number limit 1) left outer join 
			tran_header on tran_header.series = CONCAT(cin_hqtx.series_1,cin_hqtx.series_2) and tran_header.folio_number = cin_hqtx.fol_number
		where 
			date_f between unix_timestamp('2021-09-01 00:00:00') and unix_timestamp('2021-10-01 00:00:00') and 
			cin_hqtx.ser_number != '(NULL SERIAL)' and 
			cin_iven.open_dept != 'Y' and 
			cin_hqtx.from_loc != '-'
		group by 
			BranchCode, 
			ItemNumber, 
			BranchItemLocation
	) as tb1 on tb1.ItemNumber = tb6.inv_number and tb1.Branch = tb6.branch and tb1.BranchItemLocation = cast(tb7.BranchItemLocation AS CHAR CHARACTER SET utf8) left outer join 
	(
		-- all INward movements to a branch within the date range
		select  
			to_branch.mbrc_label as BranchCode, 
			to_branch.mbrc_name as BranchName,
			cin_hqtx.to_loc as BranchItemLocation,
			cin_hqtx.inv_number as ItemNumber,
			cin_iven.model_name as ItemName,
			cin_iven.prd_type as ItemCategory,
			sum(cin_hqtx.total_qty) as total_qty_in,
			sum(cin_hqtx.total_cost) as total_cost_in,
			sum(if(cin_hqtx.move_type = 'P' and tran_header.mms_tran_type = 'D', cin_hqtx.total_qty, 0)) as RefundIn_qty,
			sum(if(cin_hqtx.move_type = 'P' and tran_header.mms_tran_type = 'D', cin_hqtx.total_cost, 0)) as RefundIn_cost,
			sum(if(cin_hqtx.move_type = 'P' and tran_header.mms_tran_type = 'K', cin_hqtx.total_qty, 0)) as VoidIn_qty,
			sum(if(cin_hqtx.move_type = 'P' and tran_header.mms_tran_type = 'K', cin_hqtx.total_cost, 0)) as VoidIn_cost,
			sum(if(cin_hqtx.move_type = 'P' and !(tran_header.mms_tran_type in ('D', 'K')), cin_hqtx.total_qty, 0)) as ExchangeIn_qty,
			sum(if(cin_hqtx.move_type = 'P' and !(tran_header.mms_tran_type in ('D', 'K')), cin_hqtx.total_cost, 0)) as ExchangeIn_cost,
			sum(if(cin_hqtx.move_type = 'M' and cin_hqtx.series_1 != 'S', cin_hqtx.total_qty, 0)) as LoanIn_qty,
			sum(if(cin_hqtx.move_type = 'M' and cin_hqtx.series_1 != 'S', cin_hqtx.total_cost, 0)) as LoanIn_cost,
			sum(if((cin_hqtx.move_type = 'R' and cin_hqtx.series_1 = 'S') or (cin_hqtx.move_type = 'M' and cin_hqtx.series_1 = 'S' and cin_hqtx.series_2 = 'c'), cin_hqtx.total_qty, 0)) as ShelfCountIn_qty,
			sum(if((cin_hqtx.move_type = 'R' and cin_hqtx.series_1 = 'S') or (cin_hqtx.move_type = 'M' and cin_hqtx.series_1 = 'S' and cin_hqtx.series_2 = 'c'), cin_hqtx.total_cost, 0)) as ShelfCountIn_cost,
			sum(if(cin_hqtx.move_type = 'R' and cin_hqtx.series_1 != 'S', cin_hqtx.total_qty, 0)) as PurchaseOrderIn_qty,
			sum(if(cin_hqtx.move_type = 'R' and cin_hqtx.series_1 != 'S', cin_hqtx.total_cost, 0)) as PurchaseOrderIn_cost,
			sum(if(cin_hqtx.move_type = 'T' or (cin_hqtx.move_type = 'M' and cin_hqtx.series_1 = 'S' and cin_hqtx.series_2 = 't'), cin_hqtx.total_qty, 0)) as StockTransferIn_qty,
			sum(if(cin_hqtx.move_type = 'T' or (cin_hqtx.move_type = 'M' and cin_hqtx.series_1 = 'S' and cin_hqtx.series_2 = 't'), cin_hqtx.total_cost, 0)) as StockTransferIn_cost,
			sum(if(!(cin_hqtx.move_type in ('P','T','R','M')), cin_hqtx.total_qty, 0)) as OtherIn_qty,
			sum(if(!(cin_hqtx.move_type in ('P','T','R','M')), cin_hqtx.total_cost, 0)) as OtherIn_cost
		from 
			cin_hqtx join 
			csy_mbrc to_branch on to_branch.mbrc_branch = cin_hqtx.to_branch join 
			cin_iven on cin_iven.inv_number = cin_hqtx.inv_number join 
			cin_lcst on cin_lcst.inv_number = cin_iven.inv_number and cin_lcst.branch = cin_hqtx.to_branch left outer join 
			tran_header on tran_header.series = CONCAT(cin_hqtx.series_1,cin_hqtx.series_2) and tran_header.folio_number = cin_hqtx.fol_number 
		where 
			date_f between unix_timestamp('2021-09-01 00:00:00') and unix_timestamp('2021-10-01 00:00:00') and 
			cin_hqtx.ser_number != '(NULL SERIAL)' and 
			cin_iven.open_dept != 'Y' and 
			cin_hqtx.to_loc != '-'
		group by 
			BranchCode, 
			ItemNumber, 
			BranchItemLocation
	) as tb2 on tb6.BranchCode = tb2.BranchCode and tb6.ItemNumber = tb2.ItemNumber and tb2.BranchItemLocation = cast(tb7.BranchItemLocation AS CHAR CHARACTER SET utf8) left outer join
	(
		-- walk-back inventory movements OUT, from present-day to the range end-date.
		select  
			from_branch.mbrc_label as BranchCode, 
			cin_hqtx.from_loc as BranchItemLocation,
			cin_hqtx.inv_number as ItemNumber,
			sum(cin_hqtx.total_qty) as total_qty_out,
			sum(cin_hqtx.total_cost) as total_cost_out
		from 
			cin_hqtx join 
			csy_mbrc from_branch on from_branch.mbrc_branch = cin_hqtx.from_branch join 
			cin_iven on cin_iven.inv_number = cin_hqtx.inv_number
		where 
			date_f > unix_timestamp('2021-10-01 00:00:00') and 
			cin_hqtx.ser_number != '(NULL SERIAL)' and 
			cin_iven.open_dept != 'Y' and 
			cin_hqtx.from_loc != '-'
		group by 
			BranchCode, 
			ItemNumber, 
			BranchItemLocation
	) as tb3 on tb6.BranchCode = tb3.BranchCode and tb6.ItemNumber = tb3.ItemNumber and tb3.BranchItemLocation = cast(tb7.BranchItemLocation AS CHAR CHARACTER SET utf8) left outer join
	(
		-- walk-back inventory movements IN, from present-day to the range end-date
		select  
			to_branch.mbrc_label as BranchCode, 
			cin_hqtx.to_loc as BranchItemLocation,
			cin_hqtx.inv_number as ItemNumber,
			sum(cin_hqtx.total_qty) as total_qty_in,
			sum(cin_hqtx.total_cost) as total_cost_in
		from 
			cin_hqtx join 
			csy_mbrc to_branch on to_branch.mbrc_branch = cin_hqtx.to_branch join 
			cin_iven on cin_iven.inv_number = cin_hqtx.inv_number
		where 
			date_f > unix_timestamp('2021-10-01 00:00:00') and 
			cin_hqtx.ser_number != '(NULL SERIAL)' and 
			cin_iven.open_dept != 'Y' and 
			cin_hqtx.to_loc != '-'
		group by 
			BranchCode, 
			ItemNumber, 
			BranchItemLocation
	) as tb4 on tb6.BranchCode = tb4.BranchCode and tb6.ItemNumber = tb4.ItemNumber and tb4.BranchItemLocation = cast(tb7.BranchItemLocation AS CHAR CHARACTER SET utf8)
where 
	(
		tb7.location_qty != 0 or 
		!isnull(tb1.BranchCode) or 
		!isnull(tb2.BranchCode) or 
		!isnull(tb3.BranchCode) or 
		!isnull(tb4.BranchCode)
	)
;




