import { FormsModule } from '@angular/forms';
import { SharedModule } from 'src/app/shared/shared.module';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { DeliverReportRoutingModule } from './deliver-report-routing.module';
import { DeliverReportComponent } from './deliver-report.component';


@NgModule({
  declarations: [
    DeliverReportComponent
  ],
  imports: [
    CommonModule,
    DeliverReportRoutingModule,
    SharedModule,
    FormsModule
  ]
})
export class DeliverReportModule { }
