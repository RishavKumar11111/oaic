import { FormControl } from '@angular/forms';
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { LayoutService } from 'src/app/services/layout/layout.service';
import { CommonService } from 'src/app/services/common.service';


@Component({
  selector: 'app-approve-purchase-order',
  templateUrl: './approve-purchase-order.component.html',
  styleUrls: ['./approve-purchase-order.component.css']
})
export class ApprovePurchaseOrderComponent implements OnInit {

    selectedPONo: any;
  constructor(
    private layoutService: LayoutService,
    private service: CommonService,
    private toastr: ToastrService,
    private router: Router) { 
      this.layoutService.setBreadcrumb('Approve Generated P.O. or Cancelled P.O.');
    }

  ngOnInit(): void {
  }

    showTable: boolean = true;
    show_generateindent_listtable: boolean = false;
    show_cancelindent_listtable: boolean = false;
    paymentInvoice: boolean = false;
    approve: boolean = false;
    loadingData: boolean = false;
    showPO: boolean = false;
    fin_year: string = '';
    generateIndentList: any = [];
    cancelledIndentList: any = [];
    generated_indent_status: any = [];
    cancelled_indent_status: any = [];
    indent_type: string = 'Generate_Indent';

  changeFinancialYear(financialYear: string) {
    this.fin_year = financialYear;
    this.loadlist();
  }
        loadlist = () => {
            if(this.indent_type == "Generate_Indent"){
                this.loadPendinglistOfGenerateIndent();
            } else {
                this.loadPendinglistOfCancelIndent();
            }            
        }
        loadPendinglistOfGenerateIndent = async () => {
            this.loadingData = true;
            let response = await this.service.get(`/dm/getPendinglistOfGenerateIndent?fin_year=${this.fin_year}`);
            this.generated_indent_status = response.filter((e: any) => { 
                e.approval_date = new Date(e.approval_date); 
                e.status = false;
                return e;
            });
            this.show_generateindent_listtable = true;
            this.show_cancelindent_listtable = false;
            this.loadingData = false;
        }
        
        loadPendinglistOfCancelIndent = async () => {
            this.loadingData = true;
            let response = await this.service.get(`/dm/getPendinglistOfCancelIndent?fin_year=${this.fin_year}`);
            this.cancelled_indent_status = response.filter((e: any) => { 
                e.approval_date = new Date(e.approval_date); 
                e.status = false;
                return e;
            });
            this.show_cancelindent_listtable = true;
            this.show_generateindent_listtable = false;
            this.loadingData = false;
        }

        approveindent = async () => {
            this.loadingData = true;            
            const selectedLIst = this.generated_indent_status.filter((item: any) =>  {
                if (item.status)
                    return item;
            } );
           
            const PONoList = selectedLIst.map((i: any) => i.PONo );
            const PermitNoList = selectedLIst.map((i: any) => i.PermitNumber );
            try {
                await this.service.post(`/dm/generateIndents`, { PONoList: PONoList, PermitNoList })
                this.toastr.success('Successfully Purchase Order generated.');
                this.loadlist();
                this.loadingData = false;
            } catch (e) {
                this.toastr.error('Server problem. Please try again.');
                console.error(e);
                this.loadingData = false;
            }
        }




        cancelindent = async () => {

            this.loadingData = true;
            let selectedLIst = this.generated_indent_status.filter((item: any) =>  {
                if (item.status)
                 return item;
                 console.log(item.status);
                 console.log(item);                 
            } );            
            let PONoList = selectedLIst.map((i: any) => i.PONo );
            
            let PermitNoList = selectedLIst.map((i: any) => i.PermitNumber );

            try {
                await this.service.post(`/dm/cancelIndents`, { PONoList: PONoList, PermitNoList });
                this.toastr.success('Successfully Purchase Order Cancelled.');
                this.loadlist();
                this.loadingData = false;
            } catch (e) {
                this.toastr.error('Server problem. Please try again.');
                console.error(e);
                this.loadingData = false;
            }
        }
        
        addCancelIndent = (indent_no: any) => {
            if(this.cancelledIndentList.includes(indent_no)) {
                let index = this.cancelledIndentList.findIndex((e: any) => e == indent_no);
                this.cancelledIndentList.splice(index, 1);
            } else {
                this.cancelledIndentList.push(indent_no);
            }
        }
        addGenerateIndent = (indent_no: any) => {
            if(this.generateIndentList.includes(indent_no)) {
                let index = this.generateIndentList.findIndex((e: any) => e == indent_no);
                this.generateIndentList.splice(index, 1);
            } else {
                this.generateIndentList.push(indent_no);
            }
        }


        PONo: FormControl = new FormControl('');
        PODetails: any = {};
        viewPurchaseOrder = async (PONo: any) => {

            this.loadingData = true;
            this.selectedPONo = PONo;
            this.PONo.setValue(PONo);
            const response = await this.service.get('/api/getPODetails?PONumber=' + PONo);
            this.PODetails = response;
            this.showTable = false;
            this.show_generateindent_listtable = false;
            this.show_cancelindent_listtable = false;
            this.loadingData = false;
            this.showPO = true;
        }
        back = () => {
            this.showPO = false;
            this.showTable = true;
            this.show_generateindent_listtable = this.indent_type == "Generate_Indent" ? true : false;
            this.show_cancelindent_listtable = this.indent_type == "Generate_Indent" ? false : true;
        }





}
