import { CommonService } from 'src/app/services/common.service';
import { Component, OnInit, Output, EventEmitter } from '@angular/core';


@Component({
  selector: 'app-financial-year',
  templateUrl: './financial-year.component.html',
  styleUrls: ['./financial-year.component.css']
})
export class FinancialYearComponent implements OnInit {

  financialYear: string = '';
  financialYearList: any = [];

  @Output() newItemEvent = new EventEmitter<string>();

  constructor(private service: CommonService) { 
    this.loadFinancialYear();
  }

  ngOnInit(): void {
  }
  loadFinancialYear = async () => {
    this.financialYearList = await this.service.get('/api/getFinYear');
    this.financialYear = this.financialYearList[0];
    this.changeFinancialYear();
  }
  changeFinancialYear() {
    this.newItemEvent.emit(this.financialYear);
  }

}
