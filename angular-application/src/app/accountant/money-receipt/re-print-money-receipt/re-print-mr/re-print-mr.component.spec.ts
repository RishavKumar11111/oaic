import { ComponentFixture, TestBed } from '@angular/core/testing';
import { TestingModules } from 'src/app/common/common.modules';

import { RePrintMrComponent } from './re-print-mr.component';

describe('RePrintMrComponent', () => {
  let component: RePrintMrComponent;
  let fixture: ComponentFixture<RePrintMrComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [TestingModules],
      declarations: [ RePrintMrComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(RePrintMrComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
