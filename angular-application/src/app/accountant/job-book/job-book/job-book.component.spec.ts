import { ComponentFixture, TestBed } from '@angular/core/testing';
import { TestingModules } from 'src/app/common/common.modules';

import { JobBookComponent } from './job-book.component';

describe('JobBookComponent', () => {
  let component: JobBookComponent;
  let fixture: ComponentFixture<JobBookComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ JobBookComponent ],
      imports: [TestingModules]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(JobBookComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
