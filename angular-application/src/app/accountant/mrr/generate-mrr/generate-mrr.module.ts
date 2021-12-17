import { TableCardModule } from './../../../shared/ui/table-card/table-card.module';
import { NgxPrintModule } from 'ngx-print';
import { FormsModule } from '@angular/forms';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { GenerateMrrRoutingModule } from './generate-mrr-routing.module';
import { GenerateMrrComponent } from './generate-mrr/generate-mrr.component';
import { SharedModule } from 'src/app/shared/shared.module';
import { MrrModule } from 'src/app/report/mrr/mrr.module';


@NgModule({
  declarations: [
    GenerateMrrComponent
  ],
  imports: [
    CommonModule,
    GenerateMrrRoutingModule,
    FormsModule,
    SharedModule,
    MrrModule,
    NgxPrintModule,
    TableCardModule
  ]
})
export class GenerateMrrModule { }
