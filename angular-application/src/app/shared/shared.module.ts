import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AmountToWordPipe } from './pipes/amount-to-word/amount-to-word.pipe';
import { FinancialYearComponent } from './components/financial-year/financial-year.component'
import { FormsModule } from '@angular/forms';
import { SearchFilterPipe } from './pipes/table-search/search-filter.pipe';


@NgModule({
  declarations: [
    AmountToWordPipe,
    FinancialYearComponent,
    SearchFilterPipe
  ],
  imports: [
    CommonModule,
    FormsModule
  ],
  exports: [
    AmountToWordPipe,
    FinancialYearComponent,
    SearchFilterPipe
  ]
})
export class SharedModule { }
