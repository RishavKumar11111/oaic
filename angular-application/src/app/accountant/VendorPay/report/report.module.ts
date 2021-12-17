import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SharedModule } from './../../../shared/shared.module';
import { FormsModule } from '@angular/forms';
import { NgxPrintModule } from 'ngx-print';

import { ReportRoutingModule } from './report-routing.module';
import { ReportComponent } from './report/report.component';


@NgModule({
  declarations: [
    ReportComponent
  ],
  imports: [
    CommonModule,
    SharedModule,
    FormsModule,
    NgxPrintModule,
    ReportRoutingModule
  ]
})
export class ReportModule { }
