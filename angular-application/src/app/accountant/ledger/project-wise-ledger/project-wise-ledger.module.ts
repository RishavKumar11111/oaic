import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SharedModule } from './../../../shared/shared.module';
import { FormsModule } from '@angular/forms';
import { NgxPrintModule } from 'ngx-print';

import { ProjectWiseLedgerRoutingModule } from './project-wise-ledger-routing.module';
import { ProjectWiseComponent } from './project-wise/project-wise.component';


@NgModule({
  declarations: [
    ProjectWiseComponent
  ],
  imports: [
    CommonModule,
    SharedModule,
    FormsModule,
    NgxPrintModule,
    ProjectWiseLedgerRoutingModule
  ]
})
export class ProjectWiseLedgerModule { }
