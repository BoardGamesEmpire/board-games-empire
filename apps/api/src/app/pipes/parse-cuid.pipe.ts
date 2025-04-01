import { PipeTransform, Injectable, BadRequestException } from '@nestjs/common';

@Injectable()
export class ParseCUIDPipe implements PipeTransform {
  private readonly startingChars = 'abcdefghijklmnopqrstuvwxyz'

  transform(value: string) {
    // Check if the value is a string and a valid CUID2
    if (typeof value !== 'string' || !this.isCuid2(value)) {
      throw new BadRequestException('Invalid CUID value');
    }

    return value;
  }

  private isCuid2(value: string) {
    const MAX_LENGTH = 32;
    return this.isCuid2Inner(value, MAX_LENGTH);
  }

  private isCuid2Inner(toCheck: string, maxLength: number): boolean {
    // Check if length is between 2 and maxLength, inclusive
    if (toCheck.length >= 2 && toCheck.length <= maxLength) {
      const first = toCheck.charAt(0);
      const tail = toCheck.slice(1);

      // Check if first character is in startingChars
      if (this.startingChars.includes(first)) {
        // Check if all remaining characters are 0-9 or a-z
        return [...tail].every(char => {
          const code = char.charCodeAt(0);
          return (code >= 48 && code <= 57) || // 0-9
                 (code >= 97 && code <= 122);  // a-z
        });
      }
    }

    return false;
  }
}
