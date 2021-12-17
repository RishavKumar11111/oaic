import { Component, OnInit, Output, EventEmitter, Input } from '@angular/core';

@Component({
  selector: 'app-search-box',
  templateUrl: './search-box.component.html',
  styleUrls: ['./search-box.component.css']
})
export class SearchBoxComponent implements OnInit {

  @Output() changeFinYear = new EventEmitter<string>();
  @Input() POType: any;
  constructor() { }

  ngOnInit(): void {
  }

  changeFinancialYear(financialYear: string) {
    this.changeFinYear.emit(financialYear);
  }

}
