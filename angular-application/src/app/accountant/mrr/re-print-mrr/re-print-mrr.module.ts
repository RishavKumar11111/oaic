import { NgxPrintModule } from 'ngx-print';
import { FormsModule } from '@angular/forms';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { RePrintMrrRoutingModule } from './re-print-mrr-routing.module';
import { RePrintMrrComponent } from './re-print-mrr/re-print-mrr.component';
import { SharedModule } from 'src/app/shared/shared.module';
import { MrrModule } from 'src/app/report/mrr/mrr.module';


@NgModule({
  declarations: [
    RePrintMrrComponent
  ],
  imports: [
    CommonModule,
    RePrintMrrRoutingModule,
    FormsModule,
    SharedModule,
    MrrModule,
    NgxPrintModule
  ]
})
export class RePrintMrrModule { }
