import { BadRequestException } from '@nestjs/common';
import { ParseCUIDPipe } from './parse-cuid.pipe';

describe('ParseCUIDPipe', () => {
  let pipe: ParseCUIDPipe;

  beforeEach(() => {
    pipe = new ParseCUIDPipe();
  });

  it('should be defined', () => {
    expect(pipe).toBeDefined();
  });

  describe('transform', () => {
    it('should pass valid CUID values', () => {
      // Valid CUIDs (assuming they start with a lowercase letter and contain only a-z, 0-9)
      const validCUIDs = [
        'a1',
        'b123',
        'c1234567890',
        'zabcdefghijk1234567890',
        'a'.padEnd(32, '0') // Max length CUID
      ];

      validCUIDs.forEach(cuid => {
        expect(pipe.transform(cuid)).toBe(cuid);
      });
    });

    it('should throw BadRequestException for invalid CUID values', () => {
      // Invalid CUIDs
      const invalidCUIDs = [
        '', // Empty string
        '1', // Too short
        '1a', // Invalid starting character (starts with number)
        'A1', // Invalid starting character (uppercase)
        'a-1', // Contains invalid character
        'a_1', // Contains invalid character
        'a'.padEnd(33, '0'), // Too long
        'a!bc', // Invalid character
        'aABC', // Uppercase characters not allowed
      ];

      invalidCUIDs.forEach(cuid => {
        expect(() => pipe.transform(cuid)).toThrow(BadRequestException);
      });
    });

    it('should throw BadRequestException for non-string values', () => {
      // @ts-expect-error Testing with non-string values
      expect(() => pipe.transform(123)).toThrow(BadRequestException);
      expect(() => pipe.transform(null)).toThrow(BadRequestException);
      expect(() => pipe.transform(undefined)).toThrow(BadRequestException);
      // @ts-expect-error Testing with non-string values
      expect(() => pipe.transform({})).toThrow(BadRequestException);
    });
  });
});
