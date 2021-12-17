import { Component, OnInit } from '@angular/core';
import { ToastrService } from 'ngx-toastr';
import { CommonService } from 'src/app/services/common.service';
import { LayoutService } from 'src/app/services/layout/layout.service';


@Component({
  selector: 'app-audit-log',
  templateUrl: './audit-log.component.html',
  styleUrls: ['./audit-log.component.css']
})
export class AuditLogComponent implements OnInit {

  constructor(
    private layoutService: LayoutService,
    private service: CommonService,
    private toastr: ToastrService) { 
    this.layoutService.setBreadcrumb('Audit Log Data');
    this.cDate = new Date(this.cDate);
    this.maxDate = new Date(new Date().setDate(this.cDate.getDate() + 1));
    this.toDate = this.cDate;
    this.fromDate = new Date(new Date().setMonth(this.cDate.getMonth() - 1));
    this.loadTable();
    }

  ngOnInit(): void {
  }

//FIXME: CDate come from server
  cDate: any = new Date();
  ledgerTable = false;
  loader = false;
  maxDate: any;
  toDate: any;
  fromDate: any;
  auditLogList: any = [];
  loadTable = async() => {
      this.loader = true;
      const data = { fromDate: this.fromDate, toDate: this.toDate }
      this.auditLogList = await this.service.post(`/admin/getDateWiseAuditLogData`, data);
      this.loader = false;
      this.ledgerTable = true;
  }
  orderBy: any;
  sortedOrderOfColumn = (x: any) => {
      this.orderBy = x;
  }



}
