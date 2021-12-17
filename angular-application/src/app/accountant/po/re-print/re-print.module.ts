import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { RePrintRoutingModule } from './re-print-routing.module';
import { RePrintComponent } from './re-print/re-print.component';
import { SharedModule } from 'src/app/shared/shared.module';
import { FormsModule } from '@angular/forms';
import { PoModule } from 'src/app/report/po/po.module';
import { NgxPrintModule } from 'ngx-print';


@NgModule({
  declarations: [
    RePrintComponent
  ],
  imports: [
    CommonModule,
    RePrintRoutingModule,
    SharedModule,
    FormsModule,
    PoModule,
    NgxPrintModule
  ]
})
export class RePrintModule { }
