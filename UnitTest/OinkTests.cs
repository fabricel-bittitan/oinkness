using System;

using NUnit.Framework;

using JenkinsTest;

namespace UnitTest
{
    [TestFixture]
    [Category("JenkinsTest.Oink")]
    class OinkTests
    {
        [Test]
        public void Should_Success_When_Empty()
        {
            // Arrange
            Oink oink = new Oink();
            // Act
            // Assert
        }

        [Test]
        public void Should_Throw_When_NullParameter()
        {
            // Arrange
            // Act
            // Assert
            Assert.Throws<ArgumentNullException>(() => new Oink(null), "Should throw an Exception");
        }
    }
}
