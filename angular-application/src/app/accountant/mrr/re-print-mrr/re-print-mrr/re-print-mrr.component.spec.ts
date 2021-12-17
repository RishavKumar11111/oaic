import { ComponentFixture, TestBed } from '@angular/core/testing';
import { TestingModules } from 'src/app/common/common.modules';

import { RePrintMrrComponent } from './re-print-mrr.component';

describe('RePrintMrrComponent', () => {
  let component: RePrintMrrComponent;
  let fixture: ComponentFixture<RePrintMrrComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ RePrintMrrComponent ],
      imports: [TestingModules]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(RePrintMrrComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
