import { Component, OnInit } from '@angular/core';
import { ToastrService } from 'ngx-toastr';
import { CommonService } from 'src/app/services/common.service';
import { LayoutService } from 'src/app/services/layout/layout.service';


@Component({
  selector: 'app-payment-receive',
  templateUrl: './payment-receive.component.html',
  styleUrls: ['./payment-receive.component.css']
})
export class PaymentReceiveComponent implements OnInit {

  constructor(
    private layoutService: LayoutService,
    private service: CommonService,
    private toastr: ToastrService) { 
    this.layoutService.setBreadcrumb('Receive Payment from other Sources');
    this.loadAllSourceAndSchemas();
    }

  ngOnInit(): void {
  }




  loadingData = true;
  first_box = false;
  second_page = false;
  schemeList: any = [];
  sourceList: any = [];
  componentList: any = [];
  scheme: any = '';
  source: any = '';
  component: any = '';
  mode: string = '';
  refInfo: string = '';
  amount: any;
  ref_no: any;
  remark: any;
  payment_date: any;
//   FIXME: Serverside date
  cDate: any = new Date();
  loadAllSourceAndSchemas = async () => {
      try {
        let allSources = this.service.get('/admin/getAllSource');
        this.schemeList = await this.service.get('/admin/getAllSchema');
        this.sourceList = await allSources;
        this.loadingData = false;
        this.first_box = true;
    } catch (e) {
        console.error(e);
    }
  }
  loadComponents = async() => {
      try {
        this.componentList = await this.service.get('/admin/getComponentsOfSchema?schemaId=' + this.scheme.schem_id);
      } catch (e) {
          console.error(e);
      }
  }
  addRefNoText = () => {
      switch (this.mode) {
          case 'dd':
              {
                  this.refInfo = 'Enter DD number';
                  break;
              }
          case 'cash':
              {
                  this.refInfo = 'Enter VOUCHER number';
                  break;
              }
          case 'cheque':
              {
                  this.refInfo = 'Enter CHEQUE number';
                  break;
              }
          case 'net_banking':
              {
                  this.refInfo = 'Enter Transaction ID';
                  break;
              }
      }
  }
  addPayment = async() => {
      let payment_data = {
          amount: this.amount,
          payment_no: this.ref_no,
          payment_mode: this.mode,
          ref_no: this.ref_no,
          remark: this.remark,
          source_id: this.source.source_id,
          payment_date: this.payment_date,
      }
      let payment_desc_data = {
          source_id: this.source.source_id,
          schem_id: this.scheme.schem_id,
          comp_id: this.component.comp_id,
          ref_no: this.ref_no
      }
      try {
          const data = { payment_data: payment_data, payment_desc_data: payment_desc_data }
          await this.service.post(`/admin/addReceivedPayment`, data);
          this.toastr.success('Payment succefully received.');
          this.loadAllSourceAndSchemas();
        //   FIXME: Reset the form after submit
      } catch (e) {
          this.toastr.error('Transaction failed. Please try again.');
          console.error(e);
      }
  }
  goto2ndPage = () => {
      this.first_box = false;
      this.second_page = true;
  }
  goto1stPage = () => {
      this.second_page = false;
      this.first_box = true;
  }

}
