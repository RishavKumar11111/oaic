import { FormsModule } from '@angular/forms';
import { SharedModule } from './../../shared/shared.module';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { AllPoListRoutingModule } from './all-po-list-routing.module';
import { AllPoListComponent } from './all-po-list.component';
import { ReportModule } from 'src/app/report/report.module';
import { PoModule } from 'src/app/report/po/po.module';
import { NgxPrintModule } from 'ngx-print';
import { NormalCardModule } from 'src/app/shared/ui/normal-card/normal-card.module';
import { TableCardModule } from 'src/app/shared/ui/table-card/table-card.module';


@NgModule({
  declarations: [
    AllPoListComponent
  ],
  imports: [
    CommonModule,
    AllPoListRoutingModule,
    SharedModule,
    FormsModule,
    PoModule,
    NgxPrintModule,
    NormalCardModule,
    TableCardModule
  ]
})
export class AllPoListModule { }
