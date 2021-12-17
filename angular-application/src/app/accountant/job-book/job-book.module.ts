import { FormsModule } from '@angular/forms';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { JobBookRoutingModule } from './job-book-routing.module';
import { JobBookComponent } from './job-book/job-book.component';
import { SharedModule } from 'src/app/shared/shared.module';


@NgModule({
  declarations: [
    JobBookComponent
  ],
  imports: [
    CommonModule,
    JobBookRoutingModule,
    FormsModule,
    SharedModule
  ]
})
export class JobBookModule { }
